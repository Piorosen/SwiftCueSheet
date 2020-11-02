import Foundation

#if canImport(AVFoundation)
import AVFoundation
#endif



public struct CueSheet {
    public var meta:CSMeta
    public var rem:CSRem
    public var file:CSFile
    
    public init(meta: CSMeta, rem: CSRem, file: CSFile) {
        self.meta = meta
        self.rem = rem
        self.file = file
    }
    
    public func save(url: URL) -> Bool {
        let item = save()
        
        if let _ = (try? item.write(to: url, atomically: true, encoding: .utf8)) {
            return false
        }
        return true
        
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
    
    
    #if canImport(AVFoundation)
    private var ownAudioLength:Double = 0
    public mutating func getInfoOfAudio(music: URL) throws -> CSAudio {
        let infoOfMusic = AVAsset(url: music)
        let file = try? AVAudioFile(forReading: music)
        guard let d = file else {
            throw CSError.expireUrl(url: music)
        }
        
        self.ownAudioLength = CMTimeGetSeconds(infoOfMusic.duration)
        return CSAudio(lengthOfAudio: infoOfMusic.duration, format: d.fileFormat, length: d.length)
    }
    #endif
    
    // MARK: - 시간 데이터 계산 코드 중복 삭제 하기 위함
    #if canImport(AVFoundation)
    public func calcTime(lengthOfMusic: Double? = nil) -> [CSLengthOfAudio] {
        var length:Double = 0
        if let len = lengthOfMusic {
            length = len
        }else {
            length = ownAudioLength
        }
        
        return dCalcTime(lengthOfMusic: length)
    }
    #else
    public func calcTime(lengthOfMusic: Double = 0) -> [CSLengthOfAudio] {
        return dCalcTime(lengthOfMusic: lengthOfMusic)
    }
    #endif
    
    private func dCalcTime(lengthOfMusic: Double = 0) -> [CSLengthOfAudio] {
        var calcStartTime = 0.0
        var result = [CSLengthOfAudio]()
        
        for index in self.file.tracks.indices {
            if let sf = file.tracks[index].index.first, let sl = file.tracks[index].index.last {
                let frontInterval = sl.indexTime.totalSeconds - sf.indexTime.totalSeconds
                calcStartTime += frontInterval
                
                let startTime = calcStartTime
                
                let endTime: Double
                if let nf = file.tracks.index(of: Int(index) + 1)?.index.first {
                    endTime = nf.indexTime.totalSeconds
                }else {
                    endTime = lengthOfMusic
                }
                result.append(CSLengthOfAudio(startTime: startTime, duration: endTime - startTime, interval: frontInterval))
                calcStartTime += endTime - startTime
            }
        }
        
        return result
    }
    
}
