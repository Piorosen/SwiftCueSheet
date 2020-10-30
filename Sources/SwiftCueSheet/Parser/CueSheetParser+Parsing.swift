//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/10/29.
//

import Foundation


extension CueSheetParser {
    
    // MARK: - Parsing Data
    
    fileprivate func makeRem(_ line: String) -> (key:String, value:String)? {
        let sp = line.split(separator: " ")
                     .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        if sp.count < 3 {
            return nil
        }
        let key = sp[1].uppercased()
        let value = sp[2...].joined(separator: " ")
                            .trimmingCharacters(in: ["\"", "\'", " ", "\t", "\n"])
        
        return (key, value)
    }
    
    fileprivate func makeMeta(_ line: String) -> (key: String, value:String)? {
        let sp = line.split(separator: " ").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        if sp.count < 2 {
            return nil
        }
        
        let key = sp[0].uppercased()
        let value = sp[1...].joined(separator: " ")
                            .trimmingCharacters(in: ["\"", "\'", " ", "\t", "\n"])
        
        return (key, value)
    }
    
    fileprivate func makeIndex(_ line:String) -> CSIndex? {
        let sp = line.split(separator: " ").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        if sp.count < 3 {
            return nil
        }
        guard let num = UInt8(sp[1]) else {
            return nil
        }
        
        guard let time = CSIndexTime(time: String(sp[2])) else {
            return nil
        }
        
        return CSIndex(num: num, time: time)
    }
    
    /**
     File 안에 있는 Rem을 읽고 REM 데이터 로 반환 합니다.
     
     - Parameters:
     - data: REM 데이터 영역을 받습니다. FILE 영역이 들어가기전, COMMAND가 REM인 데이터 배열 입니다.
     
     - Returns:
     CSRem 형식으로 데이터를 반환 합니다. CSRem은 [String:String] 형식입니다.
     */
    internal func remParser(data:[String]) throws -> CSRem {
        var result = CSRem()

        for item in data {
            guard let rem = makeRem(item) else {
                throw CSError.rem(text: item, area: data.joined(separator: "\n"))
            }
            result[.init(rem.key)] = rem.value
        }
        
        return result
    }
    
    /**
     File 안에 있는 Meta을 읽고 META 데이터 로 반환 합니다.
     
     - Parameters:
     - data: META 데이터 영역을 받습니다. FILE 영역이 들어가기전, COMMAND가 META인 데이터 배열 입니다.
     
     - Returns:
     CSMeta 형식으로 데이터를 반환 합니다. CSMeta은 [String:String] 형식입니다.
     */
    internal func metaParser(data:[String]) throws -> CSMeta {
        var dicResult = CSMeta()
        
        for item in data {
            guard let meta = makeMeta(item) else {
                throw CSError.meta(text: item, area: data.joined(separator: "\n"))
            }
            
            dicResult[.init(meta.key)] = meta.value
        }
        return dicResult
    }
    
    /**
     File 데이터 안에 있는 Track을 읽고 Track 데이터 로 반환 합니다.
     
     - Parameters:
     - data: File안에 들어갈 Track 데이터를 전달 받습니다.
     
     - Returns:
     CSTrack 형식으로 데이터를 반환 합니다.
     */
    internal func trackParser(data:[String]) throws -> CSTrack {
        let trackInfo = data[0].split(separator: " ")
                                .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        if trackInfo.count < 2 {
            throw CSError.track(text: data[0], area: data.joined(separator: "\n"))
        }
        
        guard let fileIndex = Int(trackInfo[1]) else {
            throw CSError.track(text: data[0], area: data.joined(separator: "\n"))
        }
        let fileType = String(trackInfo[2])
        
        var meta = CSMeta()
        var rem = CSRem()
        var index = [CSIndex]()
        
        for line in data[1...] {
            let command = line.split(separator: " ")[0].uppercased()
            
            switch command {
            case "INDEX":
                guard let i = makeIndex(line) else {
                    throw CSError.track(text: line, area: data.joined(separator: "\n"))
                }
                index.append(i)
            case "REM":
                guard let r = makeRem(line) else {
                    throw CSError.track(text: line, area: data.joined(separator: "\n"))
                }
                rem[.init(r.key)] = r.value
            default:
                guard let m = makeMeta(line) else {
                    throw CSError.track(text: line, area: data.joined(separator: "\n"))
                }
                meta[.init(m.key)] = m.value
            }
        }
        
        return CSTrack(trackNum: fileIndex, trackType: fileType, index: index, rem: rem, meta: meta)
    }
    
    /**
     File 안에 있는 File 데이터를 읽고 File + [Track] 데이터 로 반환 합니다.
     
     - Parameters:
     - file: File에 들어가는 파일 명, 파일 타입 등등 기타 부가 정보를 받습니다.
     - track: File안에 있는 Tracks 정보를 받은 후 trackParser를 통하여 값을 구합니다.
     
     - Returns:
     CSRem 형식으로 데이터를 반환 합니다. CSRem은 [String:String] 형식입니다.
     */
    internal func fileParser(file:String, track:[[String]]) throws -> CSFile {
        let fileInfo = file.split(separator: " ").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        if file.count < 3 {
            throw CSError.file(text: file)
        }
        guard let fileType = fileInfo.last else {
            throw CSError.file(text: file)
        }
        let fileName = fileInfo[1..<(fileInfo.endIndex - 1)].joined(separator: " ")
        
        var trackList = [CSTrack]()
        
        for item in track {
            try trackList.append(trackParser(data: item))
        }
        
        return CSFile(tracks: trackList, fileName: fileName, fileType: String(fileType))
    }
    
    
}
