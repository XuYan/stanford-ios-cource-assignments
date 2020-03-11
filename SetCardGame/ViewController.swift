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
    var playingCardByCard = [Card:PlayingCard]()
    var cardByPlayingCard = [PlayingCard:Card]()
    var grid = Grid(layout: .aspectRatio(2/3))
    lazy var animator = UIDynamicAnimator(referenceView: view)

    @IBOutlet weak var cardsContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        grid.frame = cardsContainer.bounds
        addSwipeGesture(to: cardsContainer)
        addRotationGesture(to: cardsContainer)
        updateViewFromModel()
    }
    
    @IBOutlet weak var dealMore: UIButton!

    @objc func touchCard(_ sender: UIGestureRecognizer) {
        if let playingCard = sender.view as? PlayingCard, let cardModel = cardByPlayingCard[playingCard] {
            if game.isCardSelected(cardModel) {
                game.unselectCard(cardModel)
            } else {
                game.selectCard(cardModel)
            }
            updateViewFromModel([cardModel])
        }
    }
    
    private func recycleMatchedCards() {
        if game.isCardDeckEmpty() {
            removeMatchedCards()
        } else {
            replaceMatchedCards()
        }
    }
    
    private func removeMatchedCards() {
        let selectedPlayingCards = game.selectedCards.map { (cardModel) -> PlayingCard in
            self.playingCardByCard[cardModel]!
        }
        game.removeFromScreen(cards: self.game.selectedCards)
        game.clearSelectedCards()
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1,
            delay: 0,
            options: .allowUserInteraction,
            animations: {
                selectedPlayingCards.forEach { (playingCard) in
                    playingCard.alpha = 0
                }
            },
            completion: { _ in
                selectedPlayingCards.forEach { (playingCard) in
                    playingCard.removeFromSuperview()
                }
            }
        )
    }
    
    private func replaceMatchedCards() {
        let targetFrames = game.selectedCards.map { (cardModel) -> CGRect in
            self.playingCardByCard[cardModel]!.frame
        }
        removeMatchedCards()
        addNewCards()
        let count = game.cardsOnScreen.count
        for i in (count - 3)...(count - 1) {
            addPlayingCardToScreen(
                playingCard: createPlayingCard(for: game.cardsOnScreen[i]),
                delay: 1 + 0.2 * Double(i - (count - 3)), targetFrame: targetFrames[i - (count - 3)])
        }
    }
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        addNewCards()
        onMoreCardsAddedToScreen()
    }
    
    private func addNewCards() {
        do {
            try game.addNumberOfCardsToScreenFromCardDeck(numberOfCards: 3)
        } catch SetGame.GameError.insufficientCardsInDeck(let numberOfCards) {
            print("Unexpected error: card deck does not have \(numberOfCards) cards.")
        } catch {
            print("Unexpected error: \(error).")
        }
        
        if game.isCardDeckEmpty() {
            dealMore.isEnabled = false
        }
    }
    
    private func onMoreCardsAddedToScreen() {
        grid.cellCount = game.cardsOnScreen.count
        for i in 0...grid.cellCount - 4 {
            playingCardByCard[game.cardsOnScreen[i]]!.frame = grid[i]!
        }
        for i in (grid.cellCount - 3)...(grid.cellCount - 1) {
            let playingCard = createPlayingCard(for: game.cardsOnScreen[i])
            addPlayingCardToScreen(playingCard: playingCard,
                                   delay: 0.2 * Double(i - (grid.cellCount - 3)),
                                   targetFrame: grid[i]!)
        }
    }
    
    private func createPlayingCard(for card: Card) -> PlayingCard {
        let initPosition = CGPoint(x: dealMore.frame.midX, y: dealMore.frame.midY)
        let playingCard = PlayingCard(initPosition: initPosition, color: card.color.rawValue, shape: card.shape.rawValue, shading: card.shading.rawValue, number: card.number)
        playingCardByCard[card] = playingCard
        cardByPlayingCard[playingCard] = card
        return playingCard
    }
    
    private func addPlayingCardToScreen(playingCard: PlayingCard, delay: Double, targetFrame: CGRect) {
        if let card = cardByPlayingCard[playingCard] {
            playingCard.draw(isSelected: game.isCardSelected(card))
            cardsContainer.addSubview(playingCard)
            animateCardShowUp(delay: delay, targetFrame: targetFrame, playingCard: playingCard, card: card)
        }
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        game = SetGame()
        playingCardByCard = [:]
        cardByPlayingCard = [:]
        dealMore.isEnabled = true
        updateViewFromModel()
    }
    
    private func updateViewFromModel(_ cards: [Card]? = nil) {
        if cards == nil {
            updateEntireView()
        } else {
            updateView(for: cards!)
        }
        
        let match = game.findAMatch()
        if match != nil {
            if match! {
                recycleMatchedCards()
                game.clearSelectedCards()
            } else {
                let selectedCards = game.selectedCards
                selectedCards.forEach { (card) in
                    if let playingCard = playingCardByCard[card] {
                        let animation = CABasicAnimation(keyPath: "position")
                        animation.duration = 0.07
                        animation.repeatCount = 3
                        animation.autoreverses = true
                        animation.fromValue = NSValue(cgPoint: CGPoint(x: playingCard.center.x - 10, y: playingCard.center.y))
                        animation.toValue = NSValue(cgPoint: CGPoint(x: playingCard.center.x + 10, y: playingCard.center.y))

                        playingCard.layer.add(animation, forKey: "position")
                        
//                        let topAttachmentBehavior = UIAttachmentBehavior(
//                            item: playingCard,
//                            attachedToAnchor: CGPoint(
//                                x: playingCard.frame.midX,
//                                y: playingCard.frame.minY - 10))
//                        topAttachmentBehavior.frequency = 1
//                        topAttachmentBehavior.damping = 5
//
//                        let bottomAttachmentBehavior = UIAttachmentBehavior(
//                            item: playingCard,
//                            attachedToAnchor: CGPoint(
//                                x: playingCard.frame.midX,
//                                y: playingCard.frame.maxY + 10))
//                        bottomAttachmentBehavior.frequency = 1
//                        bottomAttachmentBehavior.damping = 5
//
//                        let pushBehavior = UIPushBehavior(
//                            items: [playingCard],
//                            mode: .instantaneous)
//                        pushBehavior.pushDirection = CGVector(dx: 100, dy: 0)
//
//                        animator.addBehavior(topAttachmentBehavior)
//                        animator.addBehavior(bottomAttachmentBehavior)
//                        animator.addBehavior(pushBehavior)
                    }
                }

                game.clearSelectedCards()
                updateViewFromModel(selectedCards)
            }
        }
    }
    
    private func updateEntireView() {
        removeAllPlayingCardsOnScreen()
        grid.cellCount = game.cardsOnScreen.count
        for i in 0..<grid.cellCount {
            let playingCard = createPlayingCard(for: game.cardsOnScreen[i])
            addPlayingCardToScreen(
                playingCard: playingCard,
                delay: 0.2 * Double(i),
                targetFrame: grid[i]!)
        }
    }
    
    private func removeAllPlayingCardsOnScreen() {
        cardsContainer.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func animateCardShowUp(delay: Double, targetFrame: CGRect, playingCard: PlayingCard, card: Card) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: delay,
            options: .curveEaseOut,
            animations: {
                playingCard.frame = targetFrame
            },
            completion: { position in
                self.addTapGesture(to: playingCard)
                playingCard.flip()
            }
        )
    }
    
    private func updateView(for cards: [Card]) {
        cards.forEach { (card) in
            if let playingCard = playingCardByCard[card] {
                playingCard.draw(isSelected: game.isCardSelected(card))
            }
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
        dealMoreCards(UIButton())
    }
    
    private func addRotationGesture(to: UIView) {
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:)))
        to.addGestureRecognizer(rotationGestureRecognizer)
    }
    
    @objc func rotate(_ sender: UIGestureRecognizer) {
        game.shuffle()
        updateViewFromModel()
    }
}
