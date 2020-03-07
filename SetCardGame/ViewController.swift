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
        playingCard.setSelectionState(selected: game.isCardSelected(card))
        playingCard.setBackground(gameHasMatch: game.findAMatch(), isSelected: game.isCardSelected(card))
        playingCard.setBorder()
        cardsContainer.addSubview(playingCard)
    }

    @IBOutlet weak var moreCardsButton: UIButton!

    @objc func touchCard(_ sender: UIGestureRecognizer) {
        if let playingCard = sender.view as? PlayingCard,
            let cardModel = cardModelByView[playingCard] {
                if game.isCardSelected(cardModel) {
                    game.unselectCard(cardModel)
                } else {
                    game.selectCard(cardModel)
                }
                updateViewFromModel([cardModel])
        }
    }
    
    private func removeMatchedCards() {
        let matchedPlayingCards = game.selectedCards.map { (cardModel) -> PlayingCard in
            self.cardViewByModel[cardModel]!
        }
        matchedPlayingCards.forEach { (playingCard) in
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.5,
                delay: 0,
                options: .allowUserInteraction,
                animations: {
                    playingCard.alpha = 0
                },
                completion: { _ in
                    playingCard.removeFromSuperview()
                    self.game.replaceMatchingCards()
                }
            )
        }
    }

    @IBAction func dealMoreCards(_ sender: UIButton) {
        let newCards = game.popCardsFromCardDeck(numberOfCards: 3)
        grid.cellCount = game.cardsOnScreen.count
        for i in 0..<game.cardsOnScreen.count - 3 {
            cardViewByModel[game.cardsOnScreen[i]]!.frame = grid[i]!
        }
        for i in 0...2 {
            let cardModel = newCards[i]
            let cardView = PlayingCard(frame: CGRect(), color: cardModel.color.rawValue, shape: cardModel.shape.rawValue, shading: cardModel.shading.rawValue, number: cardModel.number)
            cardViewByModel[cardModel] = cardView
            cardModelByView[cardView] = cardModel
            drawCard(playingCard: cardView, card: cardModel)
            animateCardShowUp(delay: 0.2 * Double(i), targetFrame: grid[grid.cellCount - 3 + i]!, playingCard: cardView, card: cardModel)
        }

        if game.cardDeck.count == 0 {
            moreCardsButton.isEnabled = false
        }
    }

    @IBAction func restartGame(_ sender: UIButton) {
        game = SetGame()
        cardViewByModel = [:]
        cardModelByView = [:]
        moreCardsButton.isEnabled = true
        updateViewFromModel()
    }
    
    private func updateViewFromModel(_ cards: [Card]? = nil) {
        if cards == nil {
            updateEntireView()
        } else {
            updateView(cards!)
        }
        let match = game.findAMatch()
        if match != nil {
            if match! {
                removeMatchedCards()
                // deal new cards
                game.clearSelectedCards()
            } else {
                let selectedCards = game.selectedCards
                game.clearSelectedCards()
                updateViewFromModel(selectedCards)
            }
        }
    }
    
    private func updateEntireView() {
        cardsContainer.subviews.forEach { $0.removeFromSuperview() }
        grid.cellCount = game.cardsOnScreen.count
         for i in 0..<game.cardsOnScreen.count {
             let card = game.cardsOnScreen[i]
             let playingCard = PlayingCard(frame: CGRect(), color: card.color.rawValue, shape: card.shape.rawValue, shading: card.shading.rawValue, number: card.number)
             drawCard(playingCard: playingCard, card: card)

            animateCardShowUp(delay: 0.2 * Double(i), targetFrame: grid[i]!, playingCard: playingCard, card: card)
         }
    }
    
    private func animateCardShowUp(delay: Double, targetFrame: CGRect, playingCard: PlayingCard, card: Card) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: delay,
            options: .curveEaseInOut,
            animations: {
                playingCard.frame = targetFrame
            },
            completion: { position in
                self.cardViewByModel[card] = playingCard
                self.cardModelByView[playingCard] = card
                self.addTapGesture(to: playingCard)
            }
        )
    }
    
    private func updateView(_ cards: [Card]) {
        cards.forEach { (card) in
            if let playingCard = cardViewByModel[card] {
                playingCard.setSelectionState(selected: game.isCardSelected(card))
                playingCard.setBackground(gameHasMatch: game.findAMatch(), isSelected: game.isCardSelected(card))
                playingCard.setBorder()
            }
        }
    }
    
    private func addView(_ cards: [Card]) {
        
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
        dealMoreCards(UIButton())
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
