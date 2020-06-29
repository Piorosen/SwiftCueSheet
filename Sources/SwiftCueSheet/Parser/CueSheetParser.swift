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
    
    private func remParser(data:[String]) -> [String:String] {
        var result = Rem()
        
        for item in data {
            let sp = item.split(separator: " ")
            
            let key = String(sp[1])
            let value = String(sp[2])
            
            result[key] = value
        }
        
        return result
    }
    
    private func metaParser(data:[String]) -> [String:String] {
        var dicResult = [String:String]()
        
        for item in data {
            let splited = item.split(separator: " ")
            
            dicResult[String(splited[0].uppercased())] = String(item[splited[0].endIndex...])
        }
        //(dicResult["TITLE"] ?? "", dicResult["PERFORMER"] ?? "", dicResult["SONGWRITER"] ?? "")
        return dicResult
    }
    
    private func trackParser(data:[String]) -> Track {
        let trackInfo = data[0].split(separator: " ")
        let fileIndex = Int(trackInfo[1])!
        let fileType = String(trackInfo[2])
        
        var dicResult = [String:String]()
        
        var rem = Rem()
        var soundIndex = [Index]()
        
        for index in 1 ..< data.count {
            let sp = data[index].split(separator: " ")
            
            let command = String(sp[0]).uppercased()
            
            if command == "INDEX" {
                let indexNum = Int(sp[1])!
                let indexTime = IndexTime(time: String(sp[2]))
                soundIndex.append(Index(num: UInt8(indexNum), time: indexTime!))
                
                continue
            }else if command == "REM" {
                let key = String(sp[1])
                let value = String(sp[2])
                
                rem[key] = value
            }
            
            dicResult[command] = String(data[index][command.endIndex...])
                                        .trimmingCharacters(in: ["\"", "\'", " ", "\t", "\n"])
        }
        
        return Track(item: dicResult, trackNum: fileIndex, trackType: fileType, index: soundIndex, rem: rem)
    }
    
    private func fileParser(file:String, track:[[String]]) -> File {
        let fileInfo = file.split(separator: " ")
        
        let fileType = String(fileInfo[fileInfo.count - 1])
        let fileName = String(file.split(separator: "\"")[1])
        
        var trackList = [Track]()
        
        for item in track {
            trackList.append(trackParser(data: item))
        }
        
        return File(tracks: trackList, fileName: fileName, fileType: fileType)
    }
    
    
    
    // cue -> file
    private func split(data: [String]) -> (rem:[String], meta:[String], file:String, track:[[String]])? {
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
    
    
    public func load(path:URL?, encoding:String.Encoding = .utf8) -> CueSheet? {
        if let path = path {
            guard let data = try? String(contentsOf: path, encoding: encoding) else {
                return nil
            }
            return self.load(data: data, encoding: encoding)
        }
        return nil
    }
    
    public func load(data:String?, encoding:String.Encoding = .utf8) -> CueSheet? {
        if let data = data {
            guard let read = read(data, encoding) else {
                return nil
            }
            
            if let splited = split(data: read) {
                let m = metaParser(data: splited.meta)
                let r = remParser(data: splited.rem)
                let f = fileParser(file: splited.file, track: splited.track)
                
                return CueSheet(meta: m, rem: r, file: f)
            }
        }
        return nil
    }
    
    public func getEncoding(_ path:URL) -> [String.Encoding] {
        var checkList = [String.Encoding]()
        
        checkList.append(String.Encoding.ascii)
        checkList.append(String.Encoding.iso2022JP)
        checkList.append(String.Encoding.isoLatin1)
        checkList.append(String.Encoding.isoLatin2)
        checkList.append(String.Encoding.japaneseEUC)
        checkList.append(String.Encoding.macOSRoman)
        checkList.append(String.Encoding.nextstep)
        checkList.append(String.Encoding.nonLossyASCII)
        checkList.append(String.Encoding.shiftJIS)
        checkList.append(String.Encoding.symbol)
        checkList.append(String.Encoding.unicode)
        checkList.append(String.Encoding.utf16)
        checkList.append(String.Encoding.utf16BigEndian)
        checkList.append(String.Encoding.utf16LittleEndian)
        checkList.append(String.Encoding.utf32)
        checkList.append(String.Encoding.utf32BigEndian)
        checkList.append(String.Encoding.utf32LittleEndian)
        checkList.append(String.Encoding.utf8)
        checkList.append(String.Encoding.windowsCP1250)
        checkList.append(String.Encoding.windowsCP1251)
        checkList.append(String.Encoding.windowsCP1252)
        checkList.append(String.Encoding.windowsCP1253)
        checkList.append(String.Encoding.windowsCP1254)
        
        var result = [String.Encoding]()
        
//        let loadResult = Load(path: path, encoding: encoding)
//
//        let cueName = URL(fileURLWithPath: loadResult?.file.fileName ?? "").deletingPathExtension().lastPathComponent
//        let realName = URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent
//
//        if (cueName == realName) {
//            result.append(encoding)
//        }
        
        for encoding in checkList {
            if (try? String(contentsOf: path, encoding: encoding)) != nil {
                result.append(encoding)
            }
        }
        
        return result
    }
    
    
    private func read(_ data:String, _ encoding:String.Encoding = .utf8) -> [String]? {
        if data.count == 0 {
            return nil
        }
        
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
}
