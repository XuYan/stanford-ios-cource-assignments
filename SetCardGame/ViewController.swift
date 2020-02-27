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

            cardButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
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
}

