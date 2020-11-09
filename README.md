# SwiftCueParser
Cue Parser Swift version.
![Badge](https://img.shields.io/github/license/Piorosen/SwiftCueSheet)
![Badge](https://img.shields.io/github/v/release/Piorosen/SwiftCueSheet)
![Badge](https://img.shields.io/github/workflow/status/Piorosen/SwiftCueSheet/mac-build)

## Prerequisites
  * swift >= 5.3
  

개발 범위 | 유닛테스트
---|---
MacOS |![Badge](https://img.shields.io/github/workflow/status/Piorosen/SwiftCueSheet/mac-build)
Linux | ![Badge](https://img.shields.io/github/workflow/status/Piorosen/SwiftCueSheet/ubuntu-build)
 
## 기능 추가 하는 방법

## 사용법

### 1. 전체 출력
```swift
do {
 let cueSheet = try CueSheetParser().load(data: rawText)
 for (key, value) in cueSheet.rem {
  print("\(key.caseName) : \(value)")
 }
 for (key, value) in cueSheet.meta {
  print("\(key.caseName) : \(value)")
 }
 print("\(cueSheet.file.fileName) : \(cueSheet.file.fileType)")
 for track in cueSheet.file.tracks {
  print("\(track.trackNum) : \(track.trackType)")
  for (key, value) in track.rem {
   print("\(key.caseName) : \(value)")
  }
  for (key, value) in track.meta {
   print("\(key.caseName) : \(value)")
  }
 }
}catch{
 print(error)
}
```
### 2. RawData로 CueSheet 분석 
```swift
import SwiftCueSheet

do { 
 try CueSheetParser().load(data: rawText)
} catch CSError.blankData {
 print("데이터가 비어있습니다.")
} catch CSError.rem(let line, _) {
 print("\(line) 가 문제 있습니다.")
} catch CSError.meta(let line, _) {
 print("\(line) 가 문제 있습니다.")
} catch CSError.track(let line, _) {
 print("\(line) 가 문제 있습니다.")
} catch CSError.file(let line) {
 print("\(line) 가 문제 있습니다.")
} catch CSError.splitError(let idx, let line) {
 print("\(idx)번째 줄 \(line)에 문제 있습니다.")
}
```
### 3. Url로 CueSheet 분석
```swift
import SwiftCueSheet

do { 
 try CueSheetParser().load(data: URL(fileURLWithPath: url))
} catch CSError.expireUrl(let url) {
 print("\(url)은 존재 하지 않는 파일 입니다.")
} catch CSError.blankData {
 print("데이터가 비어있습니다.")
} catch CSError.rem(let line, _) {
 print("\(line) 가 문제 있습니다.")
} catch CSError.meta(let line, _) {
 print("\(line) 가 문제 있습니다.")
} catch CSError.track(let line, _) {
 print("\(line) 가 문제 있습니다.")
} catch CSError.file(let line) {
 print("\(line) 가 문제 있습니다.")
} catch CSError.splitError(let idx, let line) {
 print("\(idx)번째 줄 \(line)에 문제 있습니다.")
}
```
