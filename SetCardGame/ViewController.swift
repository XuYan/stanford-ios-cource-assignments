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
    var cardButtonByCard = [Card:UIButton]()
    var cardByCardButton = [UIButton:Card]()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    private func drawCard(cardButton: UIButton, card: Card) {
        setBackground(cardButton: cardButton, card: card)
        setSelectionState(cardButton: cardButton, selectionState: game.isCardSelected(card: card))
        setTitle(cardButton: cardButton, card: card)
    }

    @IBOutlet weak var moreCardsButton: UIButton!
    private func getForegroundColor(card: Card) -> UIColor {
        let color = getStrokeColor(card: card)
        switch card.shading {
            case .open:
                return color.withAlphaComponent(1)
            case .solid:
                return color.withAlphaComponent(0.75)
            case .striped:
                return color.withAlphaComponent(0.15)
        }
    }
    
    private func getStrokeColor(card: Card) -> UIColor {
        switch card.color {
            case .red:
                return #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            case .green:
                return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            case .purple:
                return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        }
    }
    
    private func getStrokeWidth(card: Card) -> Double {
        switch card.shading {
            case .open:
                return 0.0
            case .solid:
                return 1.0
            case .striped:
                return 10
        }
    }

    @IBOutlet var cardCollection: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        let matching = game.getAMatch()
        if matching != nil {
            if matching! {
                game.replaceMatchingCards()
            }
            game.clearSelectedCards()
        } else {
            if let touchCard = cardByCardButton[sender] {
                if game.isCardSelected(card: touchCard) {
                    game.unselectCard(card: touchCard)
                } else {
                    game.selectCard(card: touchCard)
                }
            }
        }
        updateViewFromModel()
    }
    
    private func setSelectionState(cardButton: UIButton, selectionState: Bool) {
        if selectionState {
            cardButton.layer.borderWidth = 3.0
            cardButton.layer.borderColor = UIColor.blue.cgColor
            cardButton.layer.cornerRadius = 8.0
        } else {
            cardButton.layer.borderWidth = 0.0
            cardButton.layer.borderColor = UIColor.white.cgColor
            cardButton.layer.cornerRadius = 0.0
        }
    }
    
    private func setBackground(cardButton: UIButton, card: Card) {
        let matching = game.getAMatch()
        if matching == nil || !game.isCardSelected(card: card) {
            cardButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            cardButton.backgroundColor = matching! ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    private func setTitle(cardButton: UIButton, card: Card) {
        let attributes: [NSAttributedString.Key:Any] = [
            .font: UIFont.systemFont(ofSize: CGFloat(72 / card.number)),
            .strokeWidth : getStrokeWidth(card: card),
            .foregroundColor : getForegroundColor(card: card),
            .strokeColor : getStrokeColor(card: card)
        ]
        let attributedString = NSAttributedString(string: String(repeating: card.shape.rawValue, count: card.number), attributes: attributes)
        cardButton.setAttributedTitle(attributedString, for: UIControl.State.normal)
    }
    
    @IBAction func addMoreCards(_ sender: UIButton) {
        game.popCardsFromCardDeck(numberOfCards: 3)
        updateViewFromModel()
        
        if !hasMoreCardToAdd() {
            moreCardsButton.isEnabled = false
        }
    }

    @IBAction func restart(_ sender: UIButton) {
        game = SetGame()
        cardButtonByCard = [Card:UIButton]()
        cardByCardButton = [UIButton:Card]()
        moreCardsButton.isEnabled = true
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for i in 0..<game.cardsOnScreen.count {
            let card = game.cardsOnScreen[i]
            let cardButton = cardCollection[i]
            cardButtonByCard[card] = cardButton
            cardByCardButton[cardButton] = card

            drawCard(cardButton: cardButton, card: card)
        }
        for i in game.cardsOnScreen.count..<game.maxNumberOfCardsOnScreen {
            cardCollection[i].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            setSelectionState(cardButton: cardCollection[i], selectionState: false)
            cardCollection[i].setAttributedTitle(NSAttributedString(), for: UIControl.State.normal)
        }
    }
    
    private func hasMoreCardToAdd() -> Bool {
        return game.cardDeck.count > 0 && game.cardsOnScreen.count < game.maxNumberOfCardsOnScreen
    }
}
