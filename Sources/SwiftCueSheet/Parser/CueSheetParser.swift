//
//  CueSheet.swift
//  CueSheet
//
//  Created by Aoikazto on 2020/06/07.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation

public class CueSheetParser {
    public init() {
    }
    
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
            let value = String(sp[2]).trimmingCharacters(in: ["\"", "\'", " ", "\t", "\n"])
            
            if value.isEmpty {
                continue
            }
            
            result[key] = value
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
        var dicResult = [String:String]()
        
        for item in data {
            let splited = item.split(separator: " ")
            
            dicResult[String(splited[0].uppercased())] = String(item[splited[0].endIndex...]).trimmingCharacters(in: ["\"", "\'", " ", "\t", "\n"])
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
        
        var dicResult = [String:String]()
        
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
                
                rem[key] = value
            }else {
                let value = String(data[index][command.endIndex...]).trimmingCharacters(in: ["\"", "\'", " ", "\t", "\n"])
                if value.isEmpty {
                    continue
                }
                
                dicResult[command] = value
            }
        }
        
        return CSTrack(item: dicResult, trackNum: fileIndex, trackType: fileType, index: soundIndex, rem: rem)
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
        
        let fileType = String(fileInfo[fileInfo.count - 1])
        let fileName = String(file.split(separator: "\"")[1])
        
        var trackList = [CSTrack]()
        
        for item in track {
            trackList.append(trackParser(data: item))
        }
        
        return CSFile(tracks: trackList, fileName: fileName, fileType: fileType)
    }
    
    /**
                파일 안에 있는 모든 데이터를 Cue 파일 분석기에서 분석하기 쉬운 데이터 형식으로 변환을 합니다.
     아직 현재 데이터를 변환 할 때, 에러 처리는 아직 없습니다.
        
                - Parameters:
                    - data: 파일을 Line 기준으로 데이터를 분리 하고, 빈 데이터는 삭제가 된 상태로 받습니다.
                
                - Returns:
                    rem 데이터, meta 데이터, file 데이터, track데이터를 반환 합니다.
     */
    private func split(data: [String]) -> (rem:[String], meta:[String], file:String, track:[[String]]) {
        var remList = [String]()
        var metaList = [String]()
        var file = String()
        var trackList = [[String]]()
        
        var findFile = false
        
        var trackBuffer:[String]? = nil
        for item in data {
            let lineInfo = item.split(separator: " ")
            let command = String(lineInfo[0].uppercased())
            
            // 최초 REM 데이터 탐색
            if (command == "REM" && findFile == false) {
                remList.append(item)
            }
            // meta 데이터 탐색
            else if (findFile == false && command != "FILE" && command != "REM"){
                metaList.append(item)
            }
            // FILE 명령 찾음.
            else if (command == "FILE"){
                //                file = String(item.split(separator: "\"")[1])
                //                fileType = String(lineInfo[lineInfo.count - 1])
                file = item
                //                fileType = String(lineInfo[lineInfo.count - 1])
                findFile = true
            }
            // Track 탐색.
            else if (findFile == true && command == "TRACK"){
                if (trackBuffer != nil){
                    trackList.append(trackBuffer!)
                }
                trackBuffer = [String]()
                trackBuffer?.append(item)
            }else {
                trackBuffer?.append(item)
            }
        }
        
        if trackBuffer?.count != 0 {
            trackList.append(trackBuffer!)
        }
        
        return (remList, metaList, file, trackList)
    }
    
    /**
                파일 데이터를 입력을 받은 후 라인 데이터로 분리를 하고, 빈 공간, 빈 데이터가 있다면 필터를 통하여 삭제를 합니다.
        
                - Parameters:
                    - data: 문자열 데이터
                    - encoding: 인코딩 방식
                
                - Returns:
                    모든 데이터를 라인 데이터로 변환 한 뒤 반환 합니다.
     */
    private func read(_ data:String, _ encoding:String.Encoding = .utf8) -> [String] {
        var result = [String]()
        
        let s = data.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        for i in s.indices {
            let removedLine = String(s[i].trimmingCharacters(in: .whitespacesAndNewlines))
            if !removedLine.isEmpty {
                result.append(removedLine)
            }
        }
        
        return result
    }
    
    
    public func load(path:URL, encoding:String.Encoding = .utf8) -> CueSheet? {
        guard let data = try? String(contentsOf: path, encoding: encoding) else {
            return nil
        }
        return self.load(data: data, encoding: encoding)
    }
    
    public func load(data:String, encoding:String.Encoding = .utf8) -> CueSheet {
        let splited = split(data: read(data, encoding))
        
        let m = metaParser(data: splited.meta)
        let r = remParser(data: splited.rem)
        let f = fileParser(file: splited.file, track: splited.track)
        
        return CueSheet(meta: m, rem: r, file: f)
    }
    
    
}
