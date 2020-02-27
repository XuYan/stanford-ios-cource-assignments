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

    override func viewDidLoad() {
        super.viewDidLoad()
        print(game.cardsOnScreen.count)
        for i in 0..<game.cardsOnScreen.count {
            let card = game.cardsOnScreen[i]
            cardCollection[i].backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }

    @IBOutlet var cardCollection: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        
    }
    
    @IBAction func addMoreCards(_ sender: UIButton) {
        
    }
}

