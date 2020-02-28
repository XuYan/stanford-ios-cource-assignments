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
    var idToBeAssigned = 0
    var cardDeck: [Card] = []
    var cardsOnScreen: [Card] = []
    var selectedCards: [Card] = []
    
    init() {
        for number in 1...3 {
            Card.Color.allCases.forEach {
                let color = Card.Color(rawValue: $0.rawValue)!
                Card.Shape.allCases.forEach {
                    let shape = Card.Shape(rawValue: $0.rawValue)!
                    Card.Shading.allCases.forEach {
                        let shading = Card.Shading(rawValue: $0.rawValue)!
                        cardDeck.append(Card(id: generateId(),color: color, number: number, shape: shape, shading: shading))
                    }
                }
            }
        }
        
        for _ in 1...12 {
            cardsOnScreen.append(cardDeck.removeFirst())
        }
    }
    
    func isCardOnScreen(id: Int) -> Bool {
        return cardsOnScreen.contains {
            $0.id == id
        }
    }
    
    func isCardSelected(card: Card) -> Bool {
        return selectedCards.contains(card)
    }
    
    func selectCard(card: Card) {
        if isCardSelected(card: card) {
           return
        }
        selectedCards.append(card)
    }
    
    func unselectCard(card: Card) {
        if !isCardSelected(card: card) {
            return
        }
        let index = selectedCards.firstIndex(of: card)!
        selectedCards.remove(at: index)
    }
    
    func generateId() -> Int {
        let id = idToBeAssigned
        idToBeAssigned += 1
        return id
    }
}
