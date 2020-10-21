import Foundation

#if canImport(AVFoundation)
import AVFoundation
#endif

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}

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
            result += "REM \(item.key) \"\(item.value)\"\n"
        }
        for item in self.meta {
            result += "\(item.key) \"\(item.value)\"\n"
        }
        result += "FILE \"\(self.file.fileName)\" \(self.file.fileType)\n"
        for track in self.file.tracks {
            let idx = String(track.trackNum).leftPadding(toLength: 2, withPad: "0")
            result += "\tTRACK \(idx) \(track.trackType)\n"
            
            if track.title.count != 0 {
                result += "\t\tTITLE \"\(track.title)\"\n"
            }
            if track.performer.count != 0 {
                result += "\t\tPERFORMER \"\(track.performer)\"\n"
            }
            if track.songWriter.count != 0 {
                result += "\t\tSONGWRITER \"\(track.songWriter)\"\n"
            }
            if track.isrc.count != 0 {
                result += "\t\tISRC \"\(track.isrc)\"\n"
            }
            
            for rem in track.rem {
                result += "\t\t"
                result += "REM \(rem.key) \(rem.value)\n"
            }
            
            for index in track.index {
                result += "\t\t"
                
                let min = String(index.indexTime.minutes).leftPadding(toLength: 2, withPad: "0")
                let sec = String(index.indexTime.seconds).leftPadding(toLength: 2, withPad: "0")
                let frame = String(index.indexTime.frameBySecond).leftPadding(toLength: 2, withPad: "0")
                
                result += "INDEX \(String(index.indexNum).leftPadding(toLength: 2, withPad: "0")) \(min):\(sec):\(frame)\n"
            }
        }
        
        return result
    }
    
    
    #if canImport(AVFoundation)
    private var ownAudioLength:Double = 0
    public mutating func getInfoOfAudio(music: URL) -> CSAudio? {
        let infoOfMusic = AVAsset(url: music)
        let file = try? AVAudioFile(forReading: music)
        guard let d = file else {
            return nil
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
            var dur = 0.0
            let lastIndex = file.tracks[index].index.count - 1
            
            if index != file.tracks.count - 1 {
                let me = file.tracks[index].index[lastIndex].indexTime.frames
                let next = file.tracks[index + 1].index[0].indexTime.frames
                dur = Double((next - me)) / Double(CSIndexTime.framePerSecond)
            }else {
                let me = file.tracks[index].index[lastIndex].indexTime.totalSeconds
                dur = lengthOfMusic - me
            }
            
            var interval = 0.0
            
            if file.tracks[index].index.count != 0 {
                let shortCut = file.tracks[index].index
                interval = Double(shortCut[shortCut.count - 1].indexTime.frames - shortCut[0].indexTime.frames) / Double(CSIndexTime.framePerSecond)
            }
            
            result.append(CSLengthOfAudio(startTime: calcStartTime, duration: dur, interval: interval))
            //            file.tracks[index].duration = dur
            //            file.tracks[index].interval = interval
            //            file.tracks[index].startTime = CMTime(seconds: calcStartTime, preferredTimescale: 1000)
            
            calcStartTime += dur + interval
        }
        
        return result
    }
    
}
