//
//  PlayingCard.swift
//  SetCardGame
//
//  Created by Xu Yan on 2/29/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCard: UIView {
    @IBInspectable
    var color: String = "" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var shape: String = "" { didSet { setNeedsDisplay(); setNeedsLayout() } }

    @IBInspectable
    var shading: String = "" { didSet { setNeedsDisplay(); setNeedsLayout() } }

    @IBInspectable
    var number: Int = 1 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
        setNumber(setShading(setColor(createPath())))
    }
    
    private func createPath() -> UIBezierPath {
        if shape == "oval" {
            return createOvalPath()
        } else if shape == "diamond" {
            return createDiamondPath()
        } else {
            return createSquigglePath()
        }
    }
    
    private func createOvalPath() -> UIBezierPath {
        let rect = CGRect(x: (bounds.width - shapeWidth) / 2, y: (bounds.height - shapeHeight) / 2, width: shapeWidth, height: shapeHeight)
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        return path
    }
    
    private func createDiamondPath() -> UIBezierPath {
        let path = UIBezierPath()
        let startPoint = CGPoint(x: (bounds.width - shapeWidth) / 2, y: bounds.height / 2)
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: startPoint.x + shapeWidth / 2, y: startPoint.y - shapeHeight / 2))
        path.addLine(to: CGPoint(x: startPoint.x + shapeWidth, y: startPoint.y))
        path.addLine(to: CGPoint(x: startPoint.x + shapeWidth / 2, y: startPoint.y + shapeHeight / 2))
        path.close()
        path.addClip()
        return path
    }
    
    private func createSquigglePath() -> UIBezierPath {
        let startPoint = CGPoint(x: 123, y: 233)
        let curves = [ // cp1, cp2, to
            (CGPoint(x:  118, y: 197), CGPoint(x: 148, y: 167), CGPoint(x: 180, y: 181)),
            (CGPoint(x:  212, y: 195), CGPoint(x: 193, y: 230), CGPoint(x: 243, y: 229)),
            (CGPoint(x:  293, y: 228), CGPoint(x: 334, y: 182), CGPoint(x: 372, y: 175)),
            (CGPoint(x:  393, y: 171), CGPoint(x: 417, y: 183), CGPoint(x: 418, y: 214)),
            (CGPoint(x:  419, y: 243), CGPoint(x: 415, y: 296), CGPoint(x: 377, y: 309)),
            (CGPoint(x:  363, y: 314), CGPoint(x: 333, y: 301), CGPoint(x: 311, y: 283)),
            (CGPoint(x:  287, y: 263), CGPoint(x: 213, y: 303), CGPoint(x: 178, y: 300)),
            (CGPoint(x: 163, y: 299), CGPoint(x: 113, y: 257), CGPoint(x: 123, y: 233))
        ]

        // Draw the squiggle
        let path = UIBezierPath()
        path.move(to: startPoint)
        for (cp1, cp2, to) in curves {
            path.addCurve(to: to, controlPoint1: cp1, controlPoint2: cp2)
        }
        path.close()
        // Your code to scale, rotate and translate the squiggle

        return path
    }
    
    private func setColor(_ path: UIBezierPath) -> UIBezierPath {
        let drawColor: UIColor
        if color == "red" {
            drawColor = UIColor.red
        } else if color == "green" {
            drawColor = UIColor.green
        } else {
            drawColor = UIColor.purple
        }
        drawColor.setFill()
        drawColor.setStroke()
        return path
    }
    
    private func setShading(_ path: UIBezierPath) -> UIBezierPath {
        if shading == "open" {
            path.stroke()
        } else if shading == "stripe" {
            drawStripe()
            path.stroke()
        } else {
            path.fill()
        }
        return path
    }
    
    private func setNumber(_ path: UIBezierPath) -> UIBezierPath {
        
        return path
    }
    
    private func drawStripe() {
        let stripePath = UIBezierPath()
        var x: CGFloat = 0
        while x < bounds.width {
            stripePath.move(to: CGPoint(x: x, y: 0))
            stripePath.addLine(to: CGPoint(x: x, y: bounds.height))
            x += stripeGap
        }
        stripePath.stroke()
    }
}

extension PlayingCard {
    private struct SizeRatio {
        static let ShapeWidthToBoundsWidth: CGFloat = 0.5
        static let ShapeHeightToBoundsHeight: CGFloat = 0.5
        static let stripeGapToBoundsWidth: CGFloat = 0.02
    }
    
    private var shapeWidth: CGFloat {
        return bounds.width * SizeRatio.ShapeWidthToBoundsWidth
    }
    
    private var shapeHeight: CGFloat {
        return bounds.height * SizeRatio.ShapeHeightToBoundsHeight
    }
    
    private var stripeGap: CGFloat {
        return bounds.width * SizeRatio.stripeGapToBoundsWidth
    }
}
