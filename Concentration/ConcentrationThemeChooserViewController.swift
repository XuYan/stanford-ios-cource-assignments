//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Xu Yan on 3/11/20.
//  Copyright © 2020 Self. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {
    let themes = [
        "Animal":[ "😸", "🐶", "🐻", "🐨", "🐽", "🐝", "🐧", "🙈", "🦀" ],
        "Expression":[ "😃", "😂", "😍", "🤪", "😎", "🧐", "😡", "😵", "🥶" ]
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                }
            }
        }
    }
}
