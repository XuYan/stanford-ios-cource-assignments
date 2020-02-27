//
//  SetGame.swift
//  SetCardGame
//
//  Created by Xu Yan on 2/26/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

class SetGame {
    let maxNumberOfCardsOnScreen = 24
    var cardDeck: [Card] = []
    var cardsOnScreen: [Card] = []
    let selectedCards: [Card] = []
    
    init() {
        for number in 1...3 {
            Color.allCases.forEach {
                let color = Color(rawValue: $0.rawValue)!
                Shape.allCases.forEach {
                    let shape = Shape(rawValue: $0.rawValue)!
                    Shading.allCases.forEach {
                        let shading = Shading(rawValue: $0.rawValue)!
                        cardDeck.append(Card(color: color, number: number, shape: shape, shading: shading))
                    }
                }
            }
        }
        
        for _ in 1...12 {
            cardsOnScreen.append(cardDeck.removeFirst())
        }
    }
}
