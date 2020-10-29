//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/10/29.
//

import Foundation

extension CueSheetParser {
    /**
                파일 안에 있는 모든 데이터를 Cue 파일 분석기에서 분석하기 쉬운 데이터 형식으로 변환을 합니다.
     아직 현재 데이터를 변환 할 때, 에러 처리는 아직 없습니다.
        
                - Parameters:
                    - data: 파일을 Line 기준으로 데이터를 분리 하고, 빈 데이터는 삭제가 된 상태로 받습니다.
                
                - Returns:
                    rem 데이터, meta 데이터, file 데이터, track데이터를 반환 합니다.
     */
    
    func split(data: [String]) -> (rem:[String], meta:[String], file:String, track:[[String]]) {
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
        
        if let buffer = trackBuffer, buffer.count != 0 {
            trackList.append(buffer)
        }
        
        return (remList, metaList, file, trackList)
    }
    
}
