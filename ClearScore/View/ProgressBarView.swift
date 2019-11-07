//
//  ProgressBarView.swift
//  ClearScore
//
//  Created by Eric Sans Alvarez on 02/11/2019.
//  Copyright © 2019 Eric Sans Alvarez. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {
    
    private var backgroundLayer: CAShapeLayer!
    private var foregroundLayer: CAShapeLayer!
    private var gradientLayer: CAGradientLayer!
    
    private var currentColor: UIColor!
    
    var progress: CGFloat = 0 {
        didSet {
            didProgressUpdated()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func createProgressBar() {
        backgroundLayer = createCircularLayer(strokeColor: UIColor.clear.cgColor)
        foregroundLayer = createCircularLayer(strokeColor: UIColor.white.cgColor)
        
        backgroundLayer.strokeEnd = 0
        foregroundLayer.strokeEnd = 0
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.colors = [UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.orange.cgColor, UIColor.yellow.cgColor]
        gradientLayer.frame = frame
        gradientLayer.mask = foregroundLayer
        gradientLayer.type = .conic
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(gradientLayer)
    }
    
    private func createCircularLayer(strokeColor: CGColor) -> CAShapeLayer {
        let x = frame.width / 2
        let y = frame.height / 2
        
        let center = CGPoint(x: x, y: y)
        let padding: CGFloat = 6.0
        
        // Start on top. 0.01 as a margin for a pretty starting point
        let start: CGFloat = -(.pi / 2) + 0.01
        
        // End on top (2 times pi for the whole loop)
        let end: CGFloat = start + .pi * 2
        
        let circularPath = UIBezierPath(arcCenter: center, radius: x - padding, startAngle: start, endAngle: end, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = .round
        
        return shapeLayer
    }
    
    private func didProgressUpdated() {
        backgroundLayer.strokeEnd = progress
        foregroundLayer.strokeEnd = progress
    }
    
}
