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
    
    #if canImport(AVFoundation)
    internal var ownAudioLength:Double = 0
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
    
    
}
