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
        setSelectionState(playingCard: playingCard, selectionState: game.isCardSelected(card))
        setBorder(playingCard)
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
                updateViewFromModel(cardModel)
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
    
    private func setBorder(_ playingCard: PlayingCard) {
        playingCard.layer.borderWidth = 2
        playingCard.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    private func setBackground(playingCard: PlayingCard, card: Card) {
        let matching = game.isAMatch()
        if matching == nil {
            playingCard.backgroundColor = game.isCardSelected(card) ? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            if (!game.isCardSelected(card)) {
                playingCard.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                playingCard.backgroundColor = matching! ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            }
        }
    }
    
    @IBAction func addMoreCards(_ sender: UIButton) {
        game.popCardsFromCardDeck(numberOfCards: 3)
        // TODO: This is wrong!
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
    
    private func updateViewFromModel(_ card: Card? = nil) {
        if card == nil {
            updateEntireView()
        } else {
            updateSingleCardView(card!)
        }
        let match = game.isAMatch()
        if match != nil {
            if match! {
                removeMatchedCards()
                // deal new cards
            } else {
                // remove color
            }
            game.clearSelectedCards()
        }
    }
    
    private func updateEntireView() {
        cardsContainer.subviews.forEach { $0.removeFromSuperview() }
        grid.cellCount = game.cardsOnScreen.count
         for i in 0..<game.cardsOnScreen.count {
             let card = game.cardsOnScreen[i]
             let playingCard = PlayingCard(frame: CGRect(), color: card.color.rawValue, shape: card.shape.rawValue, shading: card.shading.rawValue, number: card.number)
             drawCard(playingCard: playingCard, card: card)

             UIViewPropertyAnimator.runningPropertyAnimator(
                 withDuration: 0.5,
                 delay: 0.2 * Double(i),
                 options: .curveEaseInOut,
                 animations: {
                     playingCard.frame = self.grid[i]!
                 },
                 completion: { position in
                     self.cardViewByModel[card] = playingCard
                     self.cardModelByView[playingCard] = card
                     self.addTapGesture(to: playingCard)
                 }
             )
         }
    }
    
    private func updateSingleCardView(_ card: Card) {
        if let playingCard = cardViewByModel[card] {
            setBackground(playingCard: playingCard, card: card)
            setSelectionState(playingCard: playingCard, selectionState: game.isCardSelected(card))
            setBorder(playingCard)
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
