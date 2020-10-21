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
        return false
    }
    public func save() -> String {
        return ""
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
                let me = file.tracks[index].index[lastIndex].indexTime.seconds
                dur = lengthOfMusic - me
            }
            
            var interval = 0.0
            
            if file.tracks[index].index.count != 0 {
                let shortCut = file.tracks[index].index
                interval = Double(shortCut[shortCut.count - 1].indexTime.frames - shortCut[0].indexTime.frames) / Double(CSIndexTime.framePerSecond)
            }
            
            result.append(CSLengthOfAudio(startTime: calcStartTime, duration: dur))
            //            file.tracks[index].duration = dur
            //            file.tracks[index].interval = interval
            //            file.tracks[index].startTime = CMTime(seconds: calcStartTime, preferredTimescale: 1000)
            
            calcStartTime += dur + interval
        }
        
        return result
    }
    
}
