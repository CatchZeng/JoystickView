//
//  ViewController.swift
//  JoystickView
//
//  Created by CatchZeng on 04/05/2017.
//  Copyright (c) 2017 CatchZeng. All rights reserved.
//

import UIKit
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
