//
//  Card.swift
//  SetCardGame
//
//  Created by Xu Yan on 2/26/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

enum Color: String, CaseIterable {
    case red = "red"
    case green = "green"
    case blue = "blue"
}

enum Shape: String, CaseIterable {
    case diamond = "diamond"
    case squiggle = "squiggle"
    case oval = "oval"
}

enum Shading: String, CaseIterable {
    case solid = "solid"
    case striped = "striped"
    case open = "open"
}

struct Card {
    let color: Color
    let number: Int
    let shape: Shape
    let shading: Shading
}
