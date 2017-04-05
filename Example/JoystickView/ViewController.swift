//
//  ViewController.swift
//  JoystickView
//
//  Created by CatchZeng on 04/05/2017.
//  Copyright (c) 2017 CatchZeng. All rights reserved.
//

import UIKit
import JoystickView

class ViewController: UIViewController {
    
    @IBOutlet weak var horizontalJoystick: JoystickView!
    @IBOutlet weak var verticalJoystick: JoystickView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        horizontalJoystick.direction = .horizontal
        verticalJoystick.direction = .vertical
    }
}
