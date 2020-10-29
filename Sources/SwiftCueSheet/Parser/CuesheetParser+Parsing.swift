//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/10/29.
//

import Foundation

extension CueSheetParser {
    
    // MARK: - Parsing Data
    
    /**
                File 안에 있는 Rem을 읽고 REM 데이터 로 반환 합니다.
        
                - Parameters:
                    - data: REM 데이터 영역을 받습니다. FILE 영역이 들어가기전, COMMAND가 REM인 데이터 배열 입니다.
                
                - Returns:
                    CSRem 형식으로 데이터를 반환 합니다. CSRem은 [String:String] 형식입니다.
     */
    private func remParser(data:[String]) -> CSRem {
        var result = CSRem()
        
        for item in data {
            let sp = item.split(separator: " ")
            
            let key = String(sp[1])
            let value = sp[2...].joined(separator: " ").trimmingCharacters(in: ["\"", "\'", " ", "\t", "\n"])
            
            if value.isEmpty {
                continue
            }
            
            result[.init(key)] = value
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
    private func metaParser(data:[String]) -> CSMeta {
        var dicResult = CSMeta()
        
        for item in data {
            let splited = item.split(separator: " ")
            let key = String(splited[0].uppercased())
            let value = String(item[splited[0].endIndex...]).trimmingCharacters(in: ["\"", "\'", " ", "\t", "\n"])
            
            dicResult[.init(key)] = value
        }
        //(dicResult["TITLE"] ?? "", dicResult["PERFORMER"] ?? "", dicResult["SONGWRITER"] ?? "")
        return dicResult
    }
    
    /**
                File 데이터 안에 있는 Track을 읽고 Track 데이터 로 반환 합니다.
        
                - Parameters:
                    - data: File안에 들어갈 Track 데이터를 전달 받습니다.
                
                - Returns:
                    CSTrack 형식으로 데이터를 반환 합니다.
     */
    private func trackParser(data:[String]) -> CSTrack {
        let trackInfo = data[0].split(separator: " ")
        let fileIndex = Int(trackInfo[1])!
        let fileType = String(trackInfo[2])
        
        var dicResult = CSMeta()
        
        var rem = CSRem()
        var soundIndex = [CSIndex]()
        
        for index in 1 ..< data.count {
            let sp = data[index].split(separator: " ")
            
            let command = String(sp[0]).uppercased()
            
            if command == "INDEX" {
                let indexNum = Int(sp[1])!
                let indexTime = CSIndexTime(time: String(sp[2]))
                soundIndex.append(CSIndex(num: UInt8(indexNum), time: indexTime!))
                
                continue
            }else if command == "REM" {
                let key = String(sp[1])
                let value = String(sp[2]).trimmingCharacters(in: ["\"", "\'", " ", "\t", "\n"])
                
                if value.isEmpty {
                    continue
                }
                
                rem[.others(key)] = value
            }else {
                let value = String(data[index][command.endIndex...]).trimmingCharacters(in: ["\"", "\'", " ", "\t", "\n"])
                if value.isEmpty {
                    continue
                }
                
                dicResult[.init(command)] = value
            }
        }
        
        return CSTrack(trackNum: fileIndex, trackType: fileType, index: soundIndex, rem: rem, meta: dicResult)
    }
    
    /**
                File 안에 있는 File 데이터를 읽고 File + [Track] 데이터 로 반환 합니다.
        
                - Parameters:
                    - file: File에 들어가는 파일 명, 파일 타입 등등 기타 부가 정보를 받습니다.
                    - track: File안에 있는 Tracks 정보를 받은 후 trackParser를 통하여 값을 구합니다.
                
                - Returns:
                    CSRem 형식으로 데이터를 반환 합니다. CSRem은 [String:String] 형식입니다.
     */
    private func fileParser(file:String, track:[[String]]) -> CSFile {
        let fileInfo = file.split(separator: " ")
        
        if fileInfo.count == 0 {
            return CSFile(tracks: [CSTrack](), fileName: "", fileType: "")
        }
        let fileType = String(fileInfo[fileInfo.count - 1])
        let fileName = String(file.split(separator: "\"")[1])
        
        var trackList = [CSTrack]()
        
        for item in track {
            trackList.append(trackParser(data: item))
        }
        
        return CSFile(tracks: trackList, fileName: fileName, fileType: fileType)
    }
    
    
}
