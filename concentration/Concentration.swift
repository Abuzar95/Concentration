//
//  Concentration.swift
//  Concentration
//
//  Created by Michael Shulman on 11/21/17.
//  Copyright © 2017 com.hotmail.shulman.michael. All rights reserved.
//

import Foundation

class Concentration
{
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int?  {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }

    var isGameOver: Bool {
        return (matchesRemaining == 0)
    }
    
    var matchesRemaining = 0
    
    let scorePenalty = 1
    let scoreForMatch = 2
    var flipCount = 0
    var score = 0
    
    func restartGame() {
        for cardIndex in cards.indices {
            cards[cardIndex].isMatched = false
            cards[cardIndex].isFaceUp = false
        }
        cards = shuffle(cards: cards)
        flipCount = 0
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at \(index)): chosen not in cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard {
                if matchIndex != index {
                    // check if cards match
                    if cards[matchIndex] == cards[index] {
                        cards[matchIndex].isMatched = true
                        cards[index].isMatched = true
                        matchesRemaining -= 1
                        score += scoreForMatch
                    } else {
                        // penalize score if no match but seen before
                        if cards[index].hasBeenSeen {
                            score -= scorePenalty
                        }
                    }
                    cards[index].isFaceUp = true
                    flipCount += 1
                }
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
                flipCount += 1
            }
        }
        cards[index].hasBeenSeen = true
    }
    
    private func shuffle(cards: [Card]) -> [Card] {
        var shuffledCards = [Card]()
        var unShuffledCards = cards
        for _ in cards.indices {
            let randomCard = unShuffledCards.remove(at: Int(arc4random_uniform(UInt32(unShuffledCards.count))))
            shuffledCards.append(randomCard)
        }
        return shuffledCards
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init\(numberOfPairsOfCards): must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards = shuffle(cards: cards)
        matchesRemaining = numberOfPairsOfCards
    }
}

extension Array {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
