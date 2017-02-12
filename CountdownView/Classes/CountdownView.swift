//
//  CountdownView.swift
//  Pods
//
//  Created by Tolgahan Arıkan on 12/02/2017.
//
//


import UIKit

public class CountdownView: UIView {
  
  // MARK: Singleton
  
  public class var shared: CountdownView {
    struct Singleton {
      static let instance = CountdownView(frame: CGRect.zero)
    }
    return Singleton.instance
  }
  
  // MARK: Properties
  
  fileprivate var timer: Timer!
  
  fileprivate var countdownFrom: Double! {
    didSet {
      counterLabel.text = "\(Int(countdownFrom!))"
    }
  }
  
  // MARK: Settings Interface
  
  public var frameSize = CGSize(width: 160.0, height: 160.0)
  public var framePosition = UIApplication.shared.keyWindow!.center
  
  public var spinnerLineWidth: CGFloat = 8
  public var spinnerInset: CGFloat = 8
  public var spinnerStartColor = UIColor(red:0.15, green:0.27, blue:0.33, alpha:1.0).cgColor
  public var spinnerEndColor = UIColor(red:0.79, green:0.25, blue:0.25, alpha:1.0).cgColor
  public var colorTransition = false
  
  public var contentOffset: CGFloat?
  public var counterLabelOffset: CGFloat?
  public var counterLabelFont = UIFont.boldSystemFont(ofSize: 45)
  public var counterSubtitleLabelOffset: CGFloat?
  
  // MARK: Layout
  
  private var backgroundView = UIView()
  private var contentView = UIView()
  private var spinnerCircleView = UIView()
  private var counterView = UIView()
  private var labelContainer = UIView()
  private var spinnerCircle = CAShapeLayer()
  
  public var counterLabel = UILabel()
  public var counterSubLabel = UILabel()
  
  private func setupViews() {
    
    addSubview(backgroundView)
    addSubview(contentView)
    
    backgroundView.alpha = 0
    backgroundView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
    
    contentView.frame.size = frameSize
    
    contentView.addSubview(counterView)
    contentView.addSubview(spinnerCircleView)
    
    counterView.frame.size = contentView.frame.size
    counterView.backgroundColor = .white
    counterView.layer.cornerRadius = contentView.frame.size.width/2
    counterView.layer.shadowPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)).cgPath
    counterView.layer.shadowColor = UIColor.black.cgColor
    counterView.layer.shadowRadius = 8
    counterView.layer.shadowOpacity = 0.5
    counterView.layer.shadowOffset = CGSize.zero
    
    spinnerCircleView.frame.size = contentView.frame.size
    spinnerCircle.path = UIBezierPath(ovalIn: CGRect(x: spinnerInset/2, y: spinnerInset/2,
                                                     width: frameSize.width - spinnerInset,
                                                     height: frameSize.height - spinnerInset)).cgPath
    spinnerCircle.lineWidth = spinnerLineWidth
    spinnerCircle.strokeStart = 0
    spinnerCircle.strokeEnd = 0.33
    spinnerCircle.lineCap = kCALineCapRound
    spinnerCircle.fillColor = UIColor.clear.cgColor
    spinnerCircle.strokeColor = spinnerStartColor
    spinnerCircleView.layer.addSublayer(spinnerCircle)
    
    counterView.addSubview(labelContainer)
    labelContainer.translatesAutoresizingMaskIntoConstraints = false
    labelContainer.widthAnchor.constraint(equalTo: counterView.widthAnchor).isActive = true
    labelContainer.centerXAnchor.constraint(equalTo: counterView.centerXAnchor).isActive = true
    labelContainer.centerYAnchor.constraint(equalTo: counterView.centerYAnchor).isActive = true
    
    labelContainer.addSubview(counterLabel)
    counterLabel.font = counterLabelFont
    counterLabel.textColor = UIColor.black
    counterLabel.textAlignment = .center
    counterLabel.translatesAutoresizingMaskIntoConstraints = false
    counterLabel.topAnchor.constraint(equalTo: labelContainer.topAnchor).isActive = true
    counterLabel.centerXAnchor.constraint(equalTo: labelContainer.centerXAnchor).isActive = true
    
    labelContainer.addSubview(counterSubLabel)
    counterSubLabel.font = UIFont.systemFont(ofSize: 12)
    counterSubLabel.textColor = UIColor(red:0.48, green:0.48, blue:0.49, alpha:1.0)
    counterSubLabel.textAlignment = .center
    counterSubLabel.text = "seconds"
    counterSubLabel.translatesAutoresizingMaskIntoConstraints = false
    counterSubLabel.topAnchor.constraint(equalTo: counterLabel.bottomAnchor).isActive = true
    counterSubLabel.centerXAnchor.constraint(equalTo: labelContainer.centerXAnchor).isActive = true
    counterSubLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor).isActive = true
  }
  
  //
  // observe the view frame and update the subviews layout
  //
  public override var frame: CGRect {
    didSet {
      if frame == CGRect.zero {
        return
      }
      backgroundView.frame = bounds
      contentView.center = framePosition
    }
  }
  
  // MARK: Custom superview
  
  private static weak var customSuperview: UIView? = nil
  private static func containerView() -> UIView? {
    return customSuperview ?? UIApplication.shared.keyWindow
  }
  public class func useContainerView(_ superview: UIView?) {
    customSuperview = superview
  }
  
  // MARK: Lifecycle
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Methods
  
  @discardableResult
  public class func show(countdownFrom: Double, spin: Bool, animation: Animation) -> CountdownView {
    
    let countdownView = CountdownView.shared
    countdownView.countdownFrom = countdownFrom
    
    countdownView.spin(spin)
    countdownView.updateFrame()
    countdownView.contentView.transform = CGAffineTransform.identity
    
    if countdownView.superview == nil {
      
      CountdownView.shared.setupViews()
      
      guard let containerView = containerView() else {
        fatalError("\n`UIApplication.keyWindow` is `nil`. If you're trying to show a countdown view from your view controller's `viewDidLoad` method, do that from `viewDidAppear` instead. Alternatively use `useContainerView` to set a view where the countdown view should show")
      }
      
      containerView.addSubview(countdownView)
      countdownView.animate(countdownView.backgroundView, animation: .fadeIn, options: (duration: 0.5, delay: 0), completion: nil)
      countdownView.animate(countdownView.contentView, animation: animation, options: (duration: 0.5, delay: 0.2), completion: nil)
      
      #if os(iOS)
        // Orientation change observer
        NotificationCenter.default.addObserver(
          countdownView,
          selector: #selector(CountdownView.updateFrame),
          name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
          object: nil)
      #endif
    }
    
    if let timer = countdownView.timer {
      timer.invalidate()
    }
    countdownView.timer = Timer.scheduledTimer(timeInterval: 1, target: countdownView, selector: #selector(countdownView.updateCounter),
                                               userInfo: nil, repeats: true)
    return countdownView
  }
  
  public class func show(countdownFrom: Double, spin: Bool, animation: Animation, autoHide: Bool, completion: (()->())?) {
    show(countdownFrom: countdownFrom, spin: spin, animation: animation)
    
    if autoHide {
      var autoHideAnimation: Animation!
      switch animation {
      case .fadeIn:
        autoHideAnimation = .fadeOut
      case .fadeInLeft:
        autoHideAnimation = .fadeOutRight
      case .fadeInRight:
        autoHideAnimation = .fadeInLeft
      case .zoomIn:
        autoHideAnimation = .zoomOut
      default:
        autoHideAnimation = .fadeOut
      }
      hide(animation: autoHideAnimation, options: (duration: 0.5, delay: 0.2)) {
        if completion != nil {
          completion!()
        }
      }
    } else {
      if completion != nil {
        completion!()
      }
    }
    
  }
  
  public class func hide(animation: Animation, options: (duration: Double, delay: Double), completion: (()->())?) {
    let countdownView = CountdownView.shared
    
    countdownView.animate(countdownView.contentView, animation: animation,
                          options: (duration: options.duration, delay: options.delay), completion: nil)
    countdownView.animate(countdownView.backgroundView, animation: .fadeOut,
                          options: (duration: options.duration, delay: options.delay)) {
                            countdownView.timer.invalidate()
                            countdownView.removeFromSuperview()
                            if completion != nil {
                              completion!()
                            }
    }
  }
  
  fileprivate func spin(_ spin: Bool) {
    if spin == true {
      spinnerCircle.removeAnimation(forKey: "strokeEnd")
      spinnerCircle.removeAnimation(forKey: "strokeColor")
      animate(spinnerCircleView, animation: .fadeIn, options: (duration: 0.4, delay: 0), completion: nil)
      startRotating(spinnerCircleView)
    } else {
      animate(spinnerCircleView, animation: .fadeOut, options: (duration: 0.4, delay: 0)) {
        self.stopRotating(self.spinnerCircleView)
        self.spinnerCircleView.transform = CGAffineTransform.identity
      }
    }
  }
  
  @objc fileprivate func updateCounter() {
    if countdownFrom == 2 {
      animateStrokeEnd(for: spinnerCircle, duration: 1.5)
      animateStrokeColor(for: spinnerCircle, duration: 0.6, from: spinnerStartColor, to: spinnerEndColor)
    }
    if countdownFrom == 1 {
      delay(0.6, closure: {
        self.spin(false)
      })
    }
    if countdownFrom > 0 {
      countdownFrom = countdownFrom - 1
    } else {
      timer.invalidate()
    }
  }
  
  
  func animateStrokeEnd(for shapeLayer: CAShapeLayer, duration: Double) {
    let strokeEndAnimation: CAAnimation = {
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.fromValue = 0.33
      animation.toValue = 1
      animation.duration = duration
      animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
      animation.repeatCount = 0
      animation.fillMode = kCAFillModeForwards
      animation.isRemovedOnCompletion = false
      return animation
    }()
    
    shapeLayer.add(strokeEndAnimation, forKey: "strokeEnd")
  }
  
  func animateStrokeColor(for shapeLayer: CAShapeLayer, duration: Double, from: CGColor, to: CGColor) {
    let strokeColorAnimation: CAAnimation = {
      let animation = CABasicAnimation(keyPath: "strokeColor")
      animation.fromValue = from
      animation.toValue = to
      animation.duration = duration
      animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
      animation.repeatCount = 0
      animation.fillMode = kCAFillModeForwards
      animation.isRemovedOnCompletion = false
      return animation
    }()
    
    shapeLayer.add(strokeColorAnimation, forKey: "strokeColor")
  }
  
  // MARK: Util
  
  public func updateFrame() {
    if let containerView = CountdownView.containerView() {
      CountdownView.shared.frame = containerView.bounds
    }
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    updateFrame()
  }
  
  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    return self
  }
  
  internal func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
  }
  
}

// Animations

extension CountdownView {
  
  
  // MARK: Animations
  
  public enum Animation {
    case fadeIn
    case fadeOut
    case fadeInLeft
    case fadeInRight
    case fadeOutLeft
    case fadeOutRight
    case zoomIn
    case zoomOut
  }
  
  fileprivate func animate(_ view: UIView, animation: Animation, options: (duration: Double, delay: Double), completion: (()->())?) {
    switch animation {
    case .fadeIn:
      UIView.animate(withDuration: options.duration, delay: options.delay, options: .transitionCrossDissolve, animations: {
        view.alpha = 1
      }, completion: { _ in
        if completion != nil {
          completion!()
        }
      })
    case .fadeOut:
      UIView.animate(withDuration: options.duration, delay: options.delay, options: .transitionCrossDissolve, animations: {
        view.alpha = 0
      }, completion: { _ in
        if completion != nil {
          completion!()
        }
      })
    case .fadeInLeft:
      view.center.x = view.center.x - bounds.width
      UIView.animate(withDuration: options.duration, delay: options.delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
        view.alpha = 1
        view.center.x = view.center.x + self.bounds.width
      }, completion: { _ in
        if completion != nil {
          completion!()
        }
      })
    case .fadeInRight:
      view.center.x = view.center.x + bounds.width
      UIView.animate(withDuration: options.duration, delay: options.delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
        view.alpha = 1
        view.center.x = view.center.x - self.bounds.width
      }, completion: { _ in
        if completion != nil {
          completion!()
        }
      })
    case .fadeOutLeft:
      UIView.animate(withDuration: options.duration, delay: options.delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
        self.alpha = 1
        self.center.x = view.center.x - self.bounds.width
      }, completion: { _ in
        if completion != nil {
          completion!()
        }
      })
    case .fadeOutRight:
      UIView.animate(withDuration: options.duration, delay: options.delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
        self.alpha = 1
        self.center.x = view.center.x + self.bounds.width
      }, completion: { _ in
        if completion != nil {
          completion!()
        }
      })
    case .zoomIn:
      view.alpha = 1
      view.transform = CGAffineTransform(scaleX: 0, y: 0)
      UIView.animate(withDuration: options.duration, delay: options.delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
        view.transform = CGAffineTransform(scaleX: 1, y: 1)
      }, completion: { _ in
        if completion != nil {
          completion!()
        }
      })
    case .zoomOut:
      view.alpha = 1
      view.transform = CGAffineTransform.identity
      UIView.animate(withDuration: options.duration, delay: options.delay, usingSpringWithDamping: 0.8, initialSpringVelocity: -0.8, options: .curveEaseOut, animations: {
        view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
      }, completion: { _ in
        if completion != nil {
          completion!()
        }
      })
    }
    
  }
  
  func startRotating(_ view: UIView, duration: Double = 1) {
    let kAnimationKey = "rotation"
    if view.layer.animation(forKey: kAnimationKey) == nil {
      let animate = CABasicAnimation(keyPath: "transform.rotation")
      animate.duration = duration
      animate.repeatCount = Float.infinity
      animate.fromValue = 0.0
      animate.toValue = Float(M_PI * 2.0)
      view.layer.add(animate, forKey: kAnimationKey)
    }
  }
  
  func stopRotating(_ view: UIView) {
    let kAnimationKey = "rotation"
    if view.layer.animation(forKey: kAnimationKey) != nil {
      view.layer.removeAnimation(forKey: kAnimationKey)
    }
  }
  
}
