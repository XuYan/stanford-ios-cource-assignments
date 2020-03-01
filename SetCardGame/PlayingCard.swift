//
//  PlayingCard.swift
//  SetCardGame
//
//  Created by Xu Yan on 2/29/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

class PlayingCard: UIView {
    var color: String = "" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var shape: String = "" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var shading: String = "" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var number: Int = 1 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
        createOvalPath()
    }
    
    private func createOvalPath() -> UIBezierPath {
        let oval = UIBezierPath(ovalIn: bounds)
        oval.addClip()
        return setColor(oval)
    }
    
    private func setColor(_ path: UIBezierPath) -> UIBezierPath {
        UIColor.lightGray.setFill()
        path.fill()
        return path
    }
}
