//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/10/29.
//

import Foundation

internal struct CSData {
    var rem = [String]()
    var meta = [String]()
    var file = String()
    var track = [[String]]()
}

extension CueSheetParser {
    /**
     파일 안에 있는 모든 데이터를 Cue 파일 분석기에서 분석하기 쉬운 데이터 형식으로 변환을 합니다.
     아직 현재 데이터를 변환 할 때, 에러 처리는 아직 없습니다.
     
     - Parameters:
     - data: 파일을 Line 기준으로 데이터를 분리 하고, 빈 데이터는 삭제가 된 상태로 받습니다.
     
     - Returns:
     rem 데이터, meta 데이터, file 데이터, track데이터를 반환 합니다.
     */
    
    internal func split(data: [String]) throws -> CSData {
        var result = CSData()
        
        var fileMode = false
        
        var trackBuffer = [String]()
        for idx in data.indices {
            let line = data[idx]
            guard let command = data[idx].split(separator: " ").first?.uppercased() else {
                throw CSError.splitError(line: idx, text: line)
            }
            
            switch command {
            case "REM":
                if fileMode {
                    trackBuffer.append(line)
                }else {
                    result.rem.append(line)
                }
            case "FILE":
                fileMode = true
                result.file = line
            case "TRACK":
                if !trackBuffer.isEmpty {
                    result.track.append(trackBuffer)
                }
                trackBuffer = [line]
                
            default:
                if fileMode {
                    trackBuffer.append(line)
                }else {
                    result.meta.append(line)
                }
            }
        }
        
        return result
    }
    
}
