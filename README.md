CountdownView
========================

<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift3-f48041.svg?style=flat"></a>
<a href="https://developer.apple.com/ios"><img src="https://img.shields.io/badge/platform-iOS%209%2B-blue.svg?style=flat"></a>
![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CountdownView.svg?style=flat)

## Preview

<img src="Screenshots/demo-1.gif" width="300">


## Installation

CountdownView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CountdownView"
```

## Usage
1. import the pod

  ```swift
  import CountdownView
  ```

2. use the basic show method or the one with completion block and automatic hiding

  ```swift
  CountdownView.show(countdownFrom: Double, spin: Bool, animation: Animation)
  ```

  ```swift
  CountdownView.show(countdownFrom: Double, spin: Bool, animation: Animation, autoHide: Bool, completion: (()->())?)
  ```

3. hide if you didn't use auto hiding

  ```swift
  CountdownView.hide(animation: Animation, options: (duration: Double, delay: Double), completion: (()->())?)
  ```
### Animation options

- fadeIn
- fadeOut
- fadeInLeft
- fadeInRight
- fadeOutLeft
- fadeOutRight
- zoomIn
- zoomOut

## Requirements

- iOS 9.0+
- Swift 3+
- ARC

## License

CountdownView is available under the MIT license. See the LICENSE file for more info.
