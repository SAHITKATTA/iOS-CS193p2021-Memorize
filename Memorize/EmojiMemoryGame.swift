//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Sanjay Katta on 15/02/22.
//

import SwiftUI

// ViewModel

// making our view model Observable
class EmojiMemoryGame: ObservableObject {
    
    static let emojis = ["🛥","🚀","✈️","🚇","🚡","🚘","🛺","🛵","🚲","🚜","🚛","🚓","🚗","🚑","🚙","🏎","🚂","🛩","🛸","🚁","🚢"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in emojis[pairIndex] }
    }
    
    // publish changes to view when model variable is changed
    // Swift can detect changes in struct
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
//        objectWillChange.send() publish changes to view
    }
    
}
