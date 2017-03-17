//
//  ViewController.swift
//  CountdownView
//
//  Created by tolgaarikann@gmail.com on 02/12/2017.
//  Copyright (c) 2017 tolgaarikann@gmail.com. All rights reserved.
//

import UIKit
import CountdownView

class ViewController: UIViewController {
  
  @IBOutlet weak var countDownFromTextField: UITextField!
  @IBOutlet weak var spinSwitch: UISwitch!
  @IBOutlet weak var autohideSwitch: UISwitch!
  
  @IBOutlet weak var appearingAnimationField: UITextField!
  @IBOutlet weak var disappearingAnimationField: UITextField!
  
  @IBOutlet weak var disappearingAnimationContainer: UIStackView!
  
  var appearingAnimations = ["fade in", "fade in left", "fade in right", "zoom in"]
  var disappearingAnimations = ["fade out", "fade out left", "fade out right", "zoom out"]
  
  var countDownFrom: Double = 5
  var appearingAnimation = CountdownView.Animation.fadeIn
  var disappearingAnimation = CountdownView.Animation.fadeOut
  var spin = true
  var autohide = false
  
  lazy var animationPicker: UIPickerView = {
    let picker = UIPickerView()
    picker.dataSource = self
    picker.delegate = self
    
    return picker
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "CountdownView"
    
    countDownFromTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
    autohideSwitch.isOn = false
    
    spinSwitch.addTarget(self, action: #selector(didSwitchSpinSwitch(_:)), for: .valueChanged)
    autohideSwitch.addTarget(self, action: #selector(didSwitchAutohideSwitch(_:)), for: .valueChanged)
    
    appearingAnimationField.inputView = animationPicker
    disappearingAnimationField.inputView = animationPicker
    
    appearingAnimationField.text = appearingAnimations[0]
    disappearingAnimationField.text = disappearingAnimations[0]
    
  }
  
  // MARK: Actions
  
  func didSwitchSpinSwitch(_ sender: UISwitch) {
    if sender.isOn {
      spin = true
    } else {
      spin = false
    }
  }
  
  func didSwitchAutohideSwitch(_ sender: UISwitch) {
    if sender.isOn {
      autohide = true
      
      UIView.animate(withDuration: 0.4, animations: {
        self.disappearingAnimationContainer.alpha = 0
      }) { _ in
        self.disappearingAnimationContainer.isHidden = true
        
        UIView.animate(withDuration: 0.4, animations: {
          self.view.layoutIfNeeded()
        })
      }

    } else {
      autohide = false
      
      disappearingAnimationContainer.isHidden = false
      UIView.animate(withDuration: 0.4, animations: {
        self.disappearingAnimationContainer.alpha = 1
      })
      
      UIView.animate(withDuration: 0.4, animations: {
        self.view.layoutIfNeeded()
      })
      
    }
  }
  
  func textFieldDidChange(_ sender: UITextField) {
    if let num = Double(sender.text!) {
      countDownFrom = num
    } else {
      countDownFrom = 5
    }
  }
  
  @IBAction func didTapStartCounterButton(_ sender: UIButton) {
    
    /* CUSTOMIZING THE VIEWS
       
       Great news, everyone! You can customize the views as weird or beautiful as you want!
       You can find the all public properties in source file.
     
       - Examples -

       CountdownView.shared.frameSize = CGSize(width: 200.0, height: 200.0)
       CountdownView.shared.backgroundViewColor = UIColor.cyan
       CountdownView.shared.counterViewBackgroundColor = UIColor(white: 1, alpha: 0.5)
     
    */
    
    
    /* DISMISS STYLE
     
       You can set dismiss style to close the counter with button or
       tapping the outside of counter. You can also choose the
       dismissing/hiding animation.
      
       - Examples -
     
       CountdownView.shared.dismissStyle = .byTapOnOutside
       CountdownView.shared.dismissStyleAnimation = .zoomOut
     
    */
    
    CountdownView.shared.dismissStyle = .byButton
    
    CountdownView.show(countdownFrom: countDownFrom, spin: spin, animation: appearingAnimation, autoHide: autohide,
                       completion: self.exampleCompletion)
    
    if !autohide {
      delay(countDownFrom, closure: {
        CountdownView.hide(animation: self.disappearingAnimation, options: (duration: 0.5, delay: 0.2),
                           completion: nil)
      })
    }
  }
  
  func exampleCompletion() {
    print("Hey there! I am the completion thingy you are looking for.")
  }
  
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if appearingAnimationField.isFirstResponder {
      return appearingAnimations.count
    } else {
      return disappearingAnimations.count
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if appearingAnimationField.isFirstResponder {
      return appearingAnimations[row]
    } else {
      return disappearingAnimations[row]
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if appearingAnimationField.isFirstResponder {
      appearingAnimationField.text = appearingAnimations[row]
      appearingAnimationField.resignFirstResponder()
      switch appearingAnimationField.text! {
        case appearingAnimations[0]:
          appearingAnimation = .fadeIn
        case appearingAnimations[1]:
          appearingAnimation = .fadeInLeft
        case appearingAnimations[2]:
          appearingAnimation = .fadeInRight
        case appearingAnimations[3]:
          appearingAnimation = .zoomIn
        default: break
      }
    } else {
      disappearingAnimationField.text = disappearingAnimations[row]
      disappearingAnimationField.resignFirstResponder()
      switch disappearingAnimationField.text! {
      case disappearingAnimations[0]:
        disappearingAnimation = .fadeOut
      case disappearingAnimations[1]:
        disappearingAnimation = .fadeOutLeft
      case disappearingAnimations[2]:
        disappearingAnimation = .fadeOutRight
      case disappearingAnimations[3]:
        disappearingAnimation = .zoomOut
      default: break
      }
    }
  }
  
}

internal func delay(_ delay:Double, closure:@escaping ()->()) {
  DispatchQueue.main.asyncAfter(
    deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

