//
//  Card.swift
//  SetCardGame
//
//  Created by Xu Yan on 2/26/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation


struct Card: Equatable, Hashable {
    let id: Int
    let color: Color
    let number: Int
    let shape: Shape
    let shading: Shading
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    enum Color: String, CaseIterable {
        case red = "red"
        case green = "green"
        case purple = "purple"
    }
    
    enum Shape: String, CaseIterable {
        case diamond = "diamond"
        case squiggle = "squiggle"
        case oval = "oval"
    }
    
    enum Shading: String, CaseIterable {
        case striped = "stripe"
        case solid = "solid"
        case open = "open"
    }
}
