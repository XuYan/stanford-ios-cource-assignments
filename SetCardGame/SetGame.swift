//
//  SetGame.swift
//  SetCardGame
//
//  Created by Xu Yan on 2/26/20.
//  Copyright © 2020 Self. All rights reserved.
//

import Foundation

struct SetGame {
    let maxNumberOfCardsOnScreen = 24
    var idToBeAssigned: Int
    var cardDeck: [Card]
    var cardsOnScreen: [Card]
    var selectedCards: [Card]
    
    init() {
        cardDeck = []
        cardsOnScreen = []
        selectedCards = []
        idToBeAssigned = 0

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
        
        shuffle()
        popCardsFromCardDeck(numberOfCards: 12)
    }
    
    func isCardOnScreen(id: Int) -> Bool {
        return cardsOnScreen.contains {
            $0.id == id
        }
    }
    
    func isCardSelected(card: Card) -> Bool {
        return selectedCards.contains(card)
    }
    
    mutating func selectCard(card: Card) {
        if isCardSelected(card: card) {
           return
        }
        selectedCards.append(card)
    }
    
    mutating func unselectCard(card: Card) {
        if !isCardSelected(card: card) {
            return
        }
        let index = selectedCards.firstIndex(of: card)!
        selectedCards.remove(at: index)
    }
    
    mutating func popCardsFromCardDeck(numberOfCards: Int) {
        for _ in 1...numberOfCards {
            cardsOnScreen.append(cardDeck.removeFirst())
        }
    }
    
    func getAMatch() -> Bool? {
        if selectedCards.count == 3 {
            let card1 = selectedCards[0]
            let card2 = selectedCards[1]
            let card3 = selectedCards[2]
            return ((card1.color == card2.color && card1.color == card3.color) || (card1.color != card2.color && card1.color != card3.color && card2.color != card3.color))
            &&
            ((card1.number == card2.number && card1.number == card3.number) || (card1.number != card2.number && card1.number != card3.number && card2.number != card3.number))
            &&
            ((card1.shading == card2.shading && card1.shading == card3.shading) || (card1.shading != card2.shading && card1.shading != card3.shading && card2.shading != card3.shading))
            &&
            ((card1.shape == card2.shape && card1.shape == card3.shape) || (card1.shape != card2.shape && card1.shape != card3.shape && card2.shape != card3.shape))
        }
        return nil
    }
    
    mutating func clearSelectedCards() {
        selectedCards = []
    }
    
    mutating func replaceMatchingCards() {
        cardsOnScreen.removeAll(where: { selectedCards.contains($0) })
        if cardDeck.count > 0 {
            popCardsFromCardDeck(numberOfCards: 3)
        }
    }
    
    mutating func shuffle() {
        let countOnScreen = cardsOnScreen.count
        cardDeck = cardDeck + cardsOnScreen
        for i in stride(from: cardDeck.count - 1, to: 1, by: -1) {
            let j = Int.random(in: 0...i)
            let temp = cardDeck[i]
            cardDeck[i] = cardDeck[j]
            cardDeck[j] = temp
        }
        cardsOnScreen = []
        if countOnScreen > 1 {
            for _ in 1...countOnScreen {
                cardsOnScreen.append(cardDeck.removeFirst())
            }
        }
        selectedCards = []
    }
    
    mutating private func generateId() -> Int {
        let id = idToBeAssigned
        idToBeAssigned += 1
        return id
    }
}
