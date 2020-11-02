//
//  File.swift
//  
//
//  Created by Aoikazto on 2020/10/27.
//

import Foundation

public struct CSFile {
    init(tracks: [CSTrack], fileName: String, fileType: String) {
        self.tracks = tracks
        self.fileName = fileName
        self.fileType = fileType
    }
    public var tracks:[CSTrack]
    public var fileName:String
    public var fileType:String
    
    
}
