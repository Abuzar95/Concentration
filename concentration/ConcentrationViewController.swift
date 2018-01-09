//
//  ViewController.swift
//  Concentration
//
//  Created by Michael Shulman on 11/21/17.
//  Copyright © 2017 com.hotmail.shulman.michael. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    override func viewDidLoad() {
//        initTheme()
        startGame()
    }
    
    lazy private var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }

    private(set) var flipCount = 0 { didSet { updateFlipCountLabel() } }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(
            string: "Flips: \(flipCount)",
            attributes: attributes
        )
        flipCountLabel.attributedText = attributedString
    
    }
    
    @IBOutlet private weak var ScoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func newGameButton(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        startGame()
    }
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons")
        }
    }

    func startGame() {
        // set up theme
        emoji.removeAll()
        remainingEmoji = emojiChoices
        
        // start game
        flipCount = 0
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                } else {
                    button.setTitle("", for: UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)  : #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                    newGameButton.isHidden = true
                }
            }
            if game.isGameOver {
                newGameButton.isHidden = false
            } else {
                newGameButton.isHidden = true
            }
            ScoreLabel.text = "\(game.score)"
        }
    }
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
        
    private var emojiChoices = "🦇😱😸😈🎃👻🍭✨🍎"
    
    private lazy var remainingEmoji = emojiChoices
    private var emoji = [Card: String]()

    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

