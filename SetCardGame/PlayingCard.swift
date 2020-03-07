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
    var color = "red" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var shape = "diamond" { didSet { setNeedsDisplay(); setNeedsLayout() } }

    @IBInspectable
    var shading = "open" { didSet { setNeedsDisplay(); setNeedsLayout() } }

    @IBInspectable
    var number = 2 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    init(frame: CGRect, color: String, shape: String, shading: String, number: Int) {
        super.init(frame: frame)
        self.color = color
        self.shape = shape
        self.shading = shading
        self.number = number
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        setColor()
        for i in 1...number {
            createPath(path, i)
        }
        path.addClip()
        setShading(path)
    }
    
    private func createPath(_ path: UIBezierPath, _ index: Int) -> UIBezierPath {
        if shape == "oval" {
            return createOvalPath(path, index)
        } else if shape == "diamond" {
            return createDiamondPath(path, index)
        } else {
            return createSquigglePath(path, index)
        }
    }
    
    private func createOvalPath(_ path: UIBezierPath, _ index: Int) -> UIBezierPath {
        let startPointX = (bounds.width - totalShapeWidth) / 2
        let offsetX = CGFloat(index - 1) * (shapeWidth + gapBetweenShapes)
        let startPointY = (bounds.height - shapeHeight) / 2
        let rect = CGRect(x: startPointX + offsetX, y: startPointY, width: shapeWidth, height: shapeHeight)
        path.append(UIBezierPath(ovalIn: rect))
        return path
    }
    
    private func createDiamondPath(_ path: UIBezierPath, _ index: Int) -> UIBezierPath {
        let startPointX = (bounds.width - totalShapeWidth) / 2
        let offsetX = CGFloat(index - 1) * (shapeWidth + gapBetweenShapes)
        let startPoint = CGPoint(x: startPointX + offsetX, y: bounds.height / 2)
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: startPoint.x + shapeWidth / 2, y: startPoint.y - shapeHeight / 2))
        path.addLine(to: CGPoint(x: startPoint.x + shapeWidth, y: startPoint.y))
        path.addLine(to: CGPoint(x: startPoint.x + shapeWidth / 2, y: startPoint.y + shapeHeight / 2))
        path.addLine(to: startPoint)
        return path
    }
    
    private func createSquigglePath(_ path: UIBezierPath, _ index: Int) -> UIBezierPath {
        let startPointX = (bounds.width - totalShapeWidth) / 2
        let offsetX = CGFloat(index - 1) * (shapeWidth + gapBetweenShapes)
        let startPoint = CGPoint(x: startPointX + offsetX, y: (bounds.height - shapeHeight) / 2)
        path.move(to: startPoint)
        path.addCurve(to: CGPoint(x: startPoint.x, y: startPoint.y + shapeHeight), controlPoint1: CGPoint(x: startPoint.x + curve, y: startPoint.y + shapeHeight / 3), controlPoint2: CGPoint(x: startPoint.x - curve, y: startPoint.y + shapeHeight / 3 * 2))
        path.addLine(to: CGPoint(x: startPoint.x + shapeWidth, y: startPoint.y + shapeHeight))
        path.addCurve(to: CGPoint(x: startPoint.x + shapeWidth, y: startPoint.y),
                      controlPoint1: CGPoint(x: startPoint.x + shapeWidth - curve, y: startPoint.y + (shapeHeight / 3) * 2),
                      controlPoint2: CGPoint(x: startPoint.x + shapeWidth + curve, y: startPoint.y + shapeHeight / 3))
        path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y))

        return path
    }
    
    private func setColor() {
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
        static let ShapeWidthToBoundsWidth: CGFloat = 0.3
        static let ShapeHeightToBoundsHeight: CGFloat = 0.5
        static let stripeGapToBoundsWidth: CGFloat = 0.05
        static let curveToShapeWidth: CGFloat = 0.35
        static let gapBetweenShapesToWidth: CGFloat = 0.025
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
    
    private var curve: CGFloat {
        return shapeWidth * SizeRatio.curveToShapeWidth
    }
    
    private var gapBetweenShapes: CGFloat {
        return shapeWidth * SizeRatio.gapBetweenShapesToWidth
    }
    
    private var totalShapeWidth: CGFloat {
        return CGFloat(number) * shapeWidth + CGFloat(number - 1) * gapBetweenShapes
    }
    
    func setBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func setBackground(gameHasMatch: Bool?, isSelected: Bool) {
        if gameHasMatch == nil {
            self.backgroundColor = isSelected ? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            if (!isSelected) {
                self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                self.backgroundColor = gameHasMatch! ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            }
        }
    }
    
    func setSelectionState(selected: Bool) {
        self.layer.cornerRadius = selected ? 8.0 : 0.0
        self.layer.masksToBounds = true
    }
}


