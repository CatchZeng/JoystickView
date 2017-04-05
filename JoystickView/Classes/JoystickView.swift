//
//  JoystickView.swift
//  JoystickView
//
//  Created by CatchZeng on 04/05/2017.
//  Copyright (c) 2017 CatchZeng. All rights reserved.
//

import UIKit

@objc public protocol JoystickViewDelegate: class {
    //x,y[0.0-1.0]
    func joystickViewDidMove(to x: Float, y: Float)
    @objc optional func joystickViewDidEndMoving()
}

@objc public enum JoystickDirection: NSInteger {
    case vertical
    case horizontal
    case around
}

open class JoystickView: UIView {
    @IBOutlet weak var joystickBg: UIView!
    @IBOutlet weak var joystickThumb: UIView!
    
    private var xValue: CGFloat = 0.0
    private var yValue: CGFloat = 0.0
    private var radius: CGFloat = 0.0
    
    private var margin: CGFloat = 0.0
    public weak var delegate: JoystickViewDelegate?
    public var direction: JoystickDirection = .around
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Touches
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
        handleTouchEnded()
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleFingerTouch(touches: touches)
        handleTouchEnded()
    }
    
    // MARK: Private Methods
    
    private func commonInit() {
        xValue = 0.0
        yValue = 0.0
        margin = 0.0
        radius = 0.0
        direction = .around
    }
    
    private func updateConstants() {
        if direction == .vertical {
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
    
    private func handleTouchEnded(){
        initJoystickCoordinate()
        delegate?.joystickViewDidEndMoving?()
        delegate?.joystickViewDidMove(to: Float(xValue), y: Float(yValue))
    }
    
    private func handleFingerTouch(touches: Set<UITouch>) {
        
        if joystickBg == nil || joystickThumb == nil {
            print("⚠️JoystickView: please check joystickBg and joystickThumb in xib or code")
            return;
        }
        
        updateConstants()
        
        var location: CGPoint = CGPoint(x: 0, y: 0)
        if let touch: UITouch = touches.first {
            location = touch.location(in: self)
            xValue = (location.x - margin) / radius - 1.0
            yValue = 1.0 - (location.y - margin) / radius
            
            var r: CGFloat
            
            switch direction {
            case .vertical:
                xValue = 0
                r = fabs(yValue * radius)
                if r >= radius {
                    xValue = 0
                    yValue = radius * (yValue / r)
                    location.y = (-yValue + 1) * radius + margin
                }
                let newY: CGFloat = location.y - joystickThumb.bounds.size.height * 0.5
                joystickThumb.frame = CGRect(origin: CGPoint.init(x: joystickThumb.frame.origin.x, y: newY ), size: joystickThumb.frame.size)
                
            case .horizontal:
                yValue = 0
                r = fabs(xValue * radius)
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
            
            delegate?.joystickViewDidMove(to: Float(xValue), y: Float(yValue))
        }
    }
}
