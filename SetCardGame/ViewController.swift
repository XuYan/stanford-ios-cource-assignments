//
//  ViewController.swift
//  SetCardGame
//
//  Created by Xu Yan on 2/26/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = SetGame()
    var playingCards = [PlayingCard]()
    var cardViewByModel = [Card:PlayingCard]()
    var cardModelByView = [PlayingCard:Card]()
    var grid = Grid(layout: .aspectRatio(2/3))

    @IBOutlet weak var cardsContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        grid.frame = cardsContainer.bounds
        addSwipeGesture(to: cardsContainer)
        addRotationGesture(to: cardsContainer)
        updateViewFromModel()
    }
    
    private func drawCard(playingCard: PlayingCard, card: Card) {
        setBackground(playingCard: playingCard, card: card)
        setSelectionState(playingCard: playingCard, selectionState: game.isCardSelected(card: card))
        playingCard.layer.borderWidth = 2
        playingCard.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cardsContainer.addSubview(playingCard)
    }

    @IBOutlet weak var moreCardsButton: UIButton!

    @objc func touchCard(_ sender: UIGestureRecognizer) {
        let matching = game.getAMatch()
        if matching != nil {
            if matching! {
                game.replaceMatchingCards()
            }
            game.clearSelectedCards()
        } else {
            if let touchCard = cardModelByView[sender.view as! PlayingCard] {
                if game.isCardSelected(card: touchCard) {
                    game.unselectCard(card: touchCard)
                } else {
                    game.selectCard(card: touchCard)
                }
            }
        }
        updateViewFromModel()
    }
    
    private func setSelectionState(playingCard: PlayingCard, selectionState: Bool) {
        if selectionState {
            playingCard.layer.borderWidth = 3.0
            playingCard.layer.borderColor = UIColor.black.cgColor
            playingCard.layer.cornerRadius = 8.0
        } else {
            playingCard.layer.borderWidth = 0.0
            playingCard.layer.borderColor = UIColor.black.cgColor
            playingCard.layer.cornerRadius = 0.0
        }
    }
    
    private func setBackground(playingCard: PlayingCard, card: Card) {
        let matching = game.getAMatch()
        if matching == nil {
            playingCard.backgroundColor = game.isCardSelected(card: card) ? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            if (!game.isCardSelected(card: card)) {
                playingCard.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                playingCard.backgroundColor = matching! ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            }
        }
    }
    
    @IBAction func addMoreCards(_ sender: UIButton) {
        game.popCardsFromCardDeck(numberOfCards: 3)
        updateViewFromModel()
        
        if game.cardDeck.count == 0 {
            moreCardsButton.isEnabled = false
        }
    }

    @IBAction func restart(_ sender: UIButton) {
        game = SetGame()
        cardViewByModel = [:]
        cardModelByView = [:]
        moreCardsButton.isEnabled = true
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        cardsContainer.subviews.forEach({ $0.removeFromSuperview() })
        grid.cellCount = game.cardsOnScreen.count
        for i in 0..<game.cardsOnScreen.count {
            let card = game.cardsOnScreen[i]
            let playingCard = PlayingCard(frame: grid[i]!, color: card.color.rawValue, shape: card.shape.rawValue, shading: card.shading.rawValue, number: card.number)
            cardViewByModel[card] = playingCard
            cardModelByView[playingCard] = card

            drawCard(playingCard: playingCard, card: card)
            addTapGesture(to: playingCard)
        }
    }
    
    private func addTapGesture(to: PlayingCard) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchCard(_:)))
        to.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addSwipeGesture(to: UIView) {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
        swipeGestureRecognizer.direction = .down
        to.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    @objc func swipeDown(_ sender: UIGestureRecognizer) {
        addMoreCards(UIButton())
    }
    
    private func addRotationGesture(to: UIView) {
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotatePiece(_:)))
        to.addGestureRecognizer(rotationGestureRecognizer)
    }
    
    @objc func rotatePiece(_ sender: UIGestureRecognizer) {
        game.shuffle()
        updateViewFromModel()
    }
}
