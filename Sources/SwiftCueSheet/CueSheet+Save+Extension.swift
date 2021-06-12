//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/11/03.
//

import Foundation

extension CueSheet {
    
    
    public func save(url: URL) -> Bool {
        let item = save()
        
        if let _ = (try? item.write(to: url, atomically: true, encoding: .utf8)) {
            return true
        }
        return false
        
    }
    public func save() -> String {
        var result = String()
        
        for item in self.rem {
            result += "REM \(item.key.caseName.uppercased()) \"\(item.value)\"\n"
        }
        for item in self.meta {
            result += "\(item.key.caseName.uppercased()) \"\(item.value)\"\n"
        }
        result += "FILE \"\(self.file.fileName)\" \(self.file.fileType)\n"
        for track in self.file.tracks {
            let idx = String(track.trackNum).leftPadding(toLength: 2, withPad: "0")
            result += "\tTRACK \(idx) \(track.trackType)\n"
            
            for meta in track.meta {
                if !meta.value.isEmpty {
                    result += "\t\t\(meta.key.caseName.uppercased()) \"\(meta.value)\"\n"
                }
            }
            
            for rem in track.rem {
                result += "\t\t"
                result += "REM \(rem.key.caseName.uppercased()) \"\(rem.value)\"\n"
            }
            
            for index in track.index {
                result += "\t\t"
                result += "INDEX \(String(index.indexNum).leftPadding(toLength: 2, withPad: "0")) \(index.indexTime)\n"
            }
        }
        
        return result
    }
    
}
