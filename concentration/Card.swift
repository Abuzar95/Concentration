//
//  Card.swift
//  Concentration
//
//  Created by Michael Shulman on 11/21/17.
//  Copyright © 2017 com.hotmail.shulman.michael. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    var hashValue: Int { return self.identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    var hasBeenSeen = false
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
