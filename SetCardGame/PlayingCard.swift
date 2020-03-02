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
        let path = UIBezierPath(ovalIn: bounds)
        path.addClip()
        return path
    }
    
    private func createDiamondPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50, y: 100))
        path.addLine(to: CGPoint(x: 100, y: 75))
        path.addLine(to: CGPoint(x: 150, y: 100))
        path.addLine(to: CGPoint(x: 100, y: 125))
        path.addLine(to: CGPoint(x: 50, y: 100))
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
        if color == "red" {
            UIColor.red.setFill()
        } else if color == "green" {
            UIColor.green.setFill()
        } else {
            UIColor.purple.setFill()
        }
        path.fill()
        return path
    }
    
    private func setShading(_ path: UIBezierPath) -> UIBezierPath {
        
        return path
    }
    
    private func setNumber(_ path: UIBezierPath) -> UIBezierPath {
        
        return path
    }
}
