
public struct CueSheet {
    public var meta:CSMeta
    public var rem:CSRem
    public var file:CSFile
    
#if canImport(AVFoundation)
    public var info:CSAudio?
#endif
}


