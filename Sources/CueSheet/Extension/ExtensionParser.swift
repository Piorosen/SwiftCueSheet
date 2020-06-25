//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/06/24.
//

import Foundation
import AVFoundation

public extension CueSheetParser {
    // 음악 파일 까지 읽고 다 동작 시킴.
    func loadFile(pathOfMusic music:URL?, pathOfCue cue:URL?, encoding: String.Encoding = .utf8) -> CueSheet? {
        if let cue = cue, let music = music {
            if !FileManager.default.fileExists(atPath: music.path) || !FileManager.default.fileExists(atPath: cue.path) {
                return nil
            }
            
            let infoOfMusic = AVAsset(url: music)
            let file = try? AVAudioFile(forReading: music)
            if file == nil {
                return nil
            }
            let info = InfoOfAudio(lengthOfAudio: infoOfMusic.duration, format: file!.fileFormat, length: file!.length)
            
            
            let lengthOfMusic = CMTimeGetSeconds(infoOfMusic.duration)
            
            let cueSheet = self.Load(path: cue, encoding: encoding)
            if var cueSheet = cueSheet {
                var calcStartTime = 0.0
                
                for index in cueSheet.file.tracks.indices {
                    var dur = 0.0
                    let lastIndex = cueSheet.file.tracks[index].index.count - 1
                    
                    if index != cueSheet.file.tracks.count - 1 {
                        let me = cueSheet.file.tracks[index].index[lastIndex].indexTime.frames
                        let next = cueSheet.file.tracks[index + 1].index[0].indexTime.frames
                        dur = Double((next - me)) / Double(IndexTime.framePerSecond)
                    }else {
                        let me = cueSheet.file.tracks[index].index[lastIndex].indexTime.seconds
                        dur = lengthOfMusic - me
                    }
                    
                    var interval = 0.0

                    if cueSheet.file.tracks[index].index.count != 0 {
                        let shortCut = cueSheet.file.tracks[index].index
                        interval = Double(shortCut.last!.indexTime.frames - shortCut.first!.indexTime.frames) / Double(IndexTime.framePerSecond)
                    }

                    cueSheet.file.tracks[index].duration = dur
                    cueSheet.file.tracks[index].interval = interval
                    cueSheet.file.tracks[index].startTime = CMTime(seconds: calcStartTime * 100, preferredTimescale: 100)
                    
                    calcStartTime += dur + interval
                    
                 
                }
                cueSheet.info = info
                return cueSheet
            }
        }
        
        return nil
    }
    
}
