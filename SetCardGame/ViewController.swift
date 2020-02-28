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
        for i in 0..<game.cardsOnScreen.count {
            let card = game.cardsOnScreen[i]
            let cardButton = cardCollection[i]
            cardButtonByCard[card] = cardButton
            cardByCardButton[cardButton] = card

            drawCard(cardButton: cardButton, card: card)
        }
    }
    
    private func drawCard(cardButton: UIButton, card: Card) {
        cardButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth : getStrokeWidth(card: card),
            .foregroundColor : getForegroundColor(card: card),
            .strokeColor : getStrokeColor(card: card)
        ]
        let attributedString = NSAttributedString(string: card.shape.rawValue, attributes: attributes)
        cardButton.setAttributedTitle(attributedString, for: UIControl.State.normal)
    }

    private func getForegroundColor(card: Card) -> UIColor {
        let color = getStrokeColor(card: card)
        switch card.shading {
            case .open:
                return color.withAlphaComponent(CGFloat(1))
            case .solid:
                return color.withAlphaComponent(CGFloat(1))
            case .striped:
                return color.withAlphaComponent(CGFloat(0.15))
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
                return -1.0
            case .striped:
                return 1.0
        }
    }

    @IBOutlet var cardCollection: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let touchCard = cardByCardButton[sender] {
            if game.isCardSelected(card: touchCard) {
                sender.layer.borderWidth = 0.0
                sender.layer.borderColor = UIColor.white.cgColor
                sender.layer.cornerRadius = 0.0
                
                game.unselectCard(card: touchCard)
            } else {
                sender.layer.borderWidth = 3.0
                sender.layer.borderColor = UIColor.blue.cgColor
                sender.layer.cornerRadius = 8.0
                
                game.selectCard(card: touchCard)
            }
        }

    }
    
    @IBAction func addMoreCards(_ sender: UIButton) {
        
    }

    @IBAction func restart(_ sender: UIButton) {
    }
}

