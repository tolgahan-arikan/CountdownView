CountdownView
========================

<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/language-swift3-f48041.svg?style=flat"></a>
<a href="https://developer.apple.com/ios"><img src="https://img.shields.io/badge/platform-iOS%209%2B-blue.svg?style=flat"></a>
![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CountdownView.svg?style=flat)

## Preview

<img src="Screenshots/demo-1.gif" width="300">


## Installation

Disclaimer note that came after 3 years: I would not suggest to actually use this. It was mostly a learning experience. In case you are trying to build something similar and trying to find a starting point, I would advise just checking the animation implementation part.

You can just add the CountdownView folder to your project,


## Usage
1. use the basic show method or the one with completion block and automatic hiding

  ```swift
  CountdownView.show(countdownFrom: Double, spin: Bool, animation: Animation)
  ```

  ```swift
  CountdownView.show(countdownFrom: Double, spin: Bool, animation: Animation, autoHide: Bool, completion: (()->())?)
  ```

2. hide if you didn't use auto hiding

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

## Customizing

  You can access the properties below from CountdownView's shared instance before you call the ```show``` function
  as you can see in the example and customize it any way you like and need.


  #### Example
  ```swift
  
  CountdownView.shared.frameSize = CGSize(width: 200.0, height: 200.0)
  
  CountdownView.shared.backgroundViewColor = UIColor.cyan
  
  CountdownView.shared.dismissStyle = .byTapOnOutside
   
  CountdownView.show(countdownFrom: Double, spin: Bool, animation: Animation)
  ```

  #### All properties
  ```swift
  public var dismissStyle: DismissStyle
  public var dismissStyleAnimation: Animation
  
  public var frameSize: CGSize
  public var framePosition: CGPoint
  
  public var backgroundViewColor: UIColor
  
  public var counterViewBackgroundColor: UIColor
  public var counterViewShadowColor: UIColor
  public var counterViewShadowRadius: CGFloat
  public var counterViewShadowOpacity: Float
  
  public var spinnerLineWidth: CGFloat
  public var spinnerInset: CGFloat
  public var spinnerStartColor: UIColor
  public var spinnerEndColor: UIColor
  public var colorTransition: Bool 
  
  public var counterLabelFont: UIFont
  public var counterLabelTextColor: UIColor
  
  public var counterSubLabelText: String
  public var counterSubLabelFont: UIFont
  public var counterSubLabelTextColor: UIColor  
  
  public var closeButtonTitleLabelText: String
  public var closeButtonTitleLabelFont: UIFont
  public var closeButtonTitleLabelColor: UIColor
  public var closeButtonTopAnchorConstant: CGFloat
  public var closeButtonLeftAnchorConstant: CGFloat
  public var closeButtonImage: UIImage
  public var closeButtonTintColor: UIColor
  ```
  
## Requirements

- iOS 9.0+
- Swift 3+

## License

CountdownView is available under the MIT license. See the LICENSE file for more info.
