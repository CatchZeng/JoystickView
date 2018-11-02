//
//  JoystickView.swift
//  JoystickView
//
//  Created by CatchZeng on 04/05/2017.
//  Copyright (c) 2017 CatchZeng. All rights reserved.
//

import UIKit

public protocol JoystickViewDelegate: class {
    //x,y [0.0 - 1.0]
    func joystickView(_ joystickView: JoystickView, didMoveto x: Float, y: Float, direction: JoystickMoveDriection)
    func joystickViewDidEndMoving(_ joystickView: JoystickView)
}

extension JoystickViewDelegate {
    func joystickView(_ joystickView: JoystickView, didMoveto x: Float, y: Float, direction: JoystickMoveDriection) {}
    func joystickViewDidEndMoving(_ joystickView: JoystickView) {}
}

public enum JoystickForm: NSInteger {
    case vertical
    case horizontal
    case around
}

public enum JoystickMoveDriection: NSInteger {
    case none
    case up
    case down
    case left
    case right
    case diagonal
}

open class JoystickView: UIView {
    @IBOutlet public weak var joystickBg: UIView!
    @IBOutlet public weak var joystickThumb: UIView!
    
    private var xValue: CGFloat = 0.0
    private var yValue: CGFloat = 0.0
    private var radius: CGFloat = 0.0
    private var margin: CGFloat = 0.0
    
    public weak var delegate: JoystickViewDelegate?
    public var form: JoystickForm = .around
    public var enable: Bool = true{
        didSet{
            self.isUserInteractionEnabled = enable
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
        initJoystickCoordinate()
        didMove()
        delegate?.joystickViewDidEndMoving(self)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
        initJoystickCoordinate()
        
        didMove()
        delegate?.joystickViewDidEndMoving(self)
    }
    
    //MARK: Private Methods
    private func commonInit() {
        xValue = 0.0
        yValue = 0.0
        margin = 0.0
        radius = 0.0
        form = .around
    }
    
    private func updateConstants() {
        if form == .vertical {
            margin = joystickThumb.frame.height/2
            radius = (bounds.height - 2 * margin) * 0.5
        }
        else {
            margin = joystickThumb.frame.width/2
            radius = (bounds.width - 2 * margin) * 0.5
        }
    }
    
    private func initJoystickCoordinate() {
        if joystickThumb != nil {
            joystickThumb.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        }
        xValue = 0.0
        yValue = 0.0
    }
    
    private func handleFingerTouch(touches: Set<UITouch>) {
        
        if joystickBg == nil || joystickThumb == nil {
            print("⚠️JoystickView: joystickBg & joystickThumb can not be nil!")
            return;
        }
        
        updateConstants()
        
        var location: CGPoint = CGPoint(x: 0, y: 0)
        if let touch: UITouch = touches.first {
            location = touch.location(in: self)
            xValue = (location.x - margin) / radius - 1.0
            yValue = 1.0 - (location.y - margin) / radius
            
            var r: CGFloat
            
            switch form {
            case .vertical:
                xValue = 0
                r = abs(yValue * radius)
                if r >= radius {
                    xValue = 0
                    yValue = radius * (yValue / r)
                    location.y = (-yValue + 1) * radius + margin
                }
                let newY: CGFloat = location.y - joystickThumb.bounds.size.height * 0.5
                joystickThumb.frame = CGRect(origin: CGPoint.init(x: joystickThumb.frame.origin.x, y: newY ), size: joystickThumb.frame.size)
                
            case .horizontal:
                yValue = 0
                r = abs(xValue * radius)
                if r >= radius {
                    yValue = 0
                    xValue = radius * (xValue / r)
                    location.x = (xValue + 1) * radius + margin
                }
                let newX: CGFloat = location.x - joystickThumb.bounds.size.width * 0.5
                joystickThumb.frame = CGRect(origin: CGPoint.init(x: newX, y: joystickThumb.frame.origin.y), size: joystickThumb.frame.size)
                
            case .around:
                r = sqrt(xValue * xValue + yValue * yValue) * radius
                if r >= radius {
                    xValue = radius * (xValue / r)
                    yValue = radius * (yValue / r)
                    
                    location.x = (xValue + 1) * radius + margin
                    location.y = (-yValue + 1) * radius + margin
                }
                let newX: CGFloat = location.x - joystickThumb.bounds.size.width * 0.5
                let newY: CGFloat = location.y - joystickThumb.bounds.size.height * 0.5
                joystickThumb.frame = CGRect(origin: CGPoint.init(x: newX, y: newY), size: joystickThumb.frame.size)
            }
            
            didMove()
        }
    }
    
    private func didMove(){
        var direction: JoystickMoveDriection = .none
        
        if (abs(xValue) > abs(yValue)) {
            direction = xValue < 0 ? .left : .right
            
        }else if (abs(xValue) == abs(yValue)) {
            direction = .diagonal
            
        }else{
            direction = yValue < 0 ? .down : .up
        }
        
        delegate?.joystickView(self, didMoveto: Float(xValue), y: Float(yValue), direction: direction)
    }
}
