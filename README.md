# JoystickView

[![Version](https://img.shields.io/cocoapods/v/JoystickView.svg?style=flat)](http://cocoapods.org/pods/JoystickView)
[![License](https://img.shields.io/cocoapods/l/JoystickView.svg?style=flat)](http://cocoapods.org/pods/JoystickView)
[![Platform](https://img.shields.io/cocoapods/p/JoystickView.svg?style=flat)](http://cocoapods.org/pods/JoystickView)

support around,vertical,horizontal directions JoystickView

![feature](https://raw.githubusercontent.com/CatchZeng/JoystickView/master/feature.png)

## Usage

1.init from code or xib. Do not forget set joystickBg and joystickThumb!

```
var joystickView = JoystickView()
joystickView.joystickBg = UIView()//replace with your custom background view
joystickView.joystickThumb = UIView()//replace with your custom thumb view

```

2.set delegate

```
joystickView.delegate = self
```


3.handle delegate

```
import JoystickView

class ViewController: UIViewController, JoystickViewDelegate{
    
    @IBOutlet weak var horizontalJoystick: JoystickView!
    @IBOutlet weak var verticalJoystick: JoystickView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        horizontalJoystick.form = .horizontal
        horizontalJoystick.delegate = self
        
        verticalJoystick.form = .vertical
        verticalJoystick.delegate = self
    }
    
    // MARK: JoystickViewDelegate
    
    func joystickView(_ joystickView: JoystickView, didMoveto x: Float, y: Float, direction: JoystickMoveDriection) {
        if joystickView == horizontalJoystick{
            print("horizontal joystick move to x:\(x) y:\(y) direction:\(direction.rawValue)")
        }else{
            print("vertical joystick move to x:\(x) y:\(y) direction:\(direction.rawValue)")
        }
    }
    
    func joystickViewDidEndMoving(_ joystickView: JoystickView) {
        if joystickView == horizontalJoystick{
            print("horizontal joystick did end moving")
        }else{
            print("vertical joystick did end moving")
        }
    }
}

```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS8+

## Installation

JoystickView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JoystickView"
```

## Author

CatchZeng, http://catchzeng.com

## License

JoystickView is available under the MIT license. See the LICENSE file for more info.
