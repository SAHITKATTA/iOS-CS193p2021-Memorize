//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Sanjay Katta on 15/02/22.
//

import SwiftUI
import Foundation

// ViewModel

// making our view model Observable
class EmojiMemoryGame: ObservableObject {

    static var themes: Array<MemoryGame<String>.Theme> = [
        MemoryGame<String>.Theme(name: "Vehicles", cardContents:  "🛥🚀✈️🚇🚡🚘🛺🛵🚲🚜🚛🚓🚗🚑🚙🏎🚂🛩🛸🚁🚢".toStringArray(), numberOfPairsOfCards: 5, color: .red),
        MemoryGame<String>.Theme(name: "Expressions", cardContents:  "😀😆🤣😂😊😇🙂😉🙃😌😜🧐😎😒😔".toStringArray(), numberOfPairsOfCards: 6, color: .blue),
        MemoryGame<String>.Theme(name: "Animals", cardContents:  "🐶🐱🐭🐹🐰🦊🐻🐼🐯🦁🐷🐸🐵🐧🐤🐣🦅🦇🦋".toStringArray(), numberOfPairsOfCards: 7, color: .yellow),
        MemoryGame<String>.Theme(name: "Food", cardContents:  "🍎🍉🍒🍓🍈🍑🍅🥝🍆🥑🥬🌽🌶🥕🥯🧀🥞🥩🧇🍗🍔🍟🍕".toStringArray(), numberOfPairsOfCards: 8, color: .orange),
        MemoryGame<String>.Theme(name: "Apple", cardContents:  "⌚️📱💻⌨️🖥🖱🎧👨‍💻".toStringArray(), color: .gray),
        MemoryGame<String>.Theme(name: "Music", cardContents:  "🎶🎼🎵🎤🎸🎧🥁🎹🎺🎻🎷🪗🪘🪕".toStringArray(), numberOfPairsOfCards: 10, color: .teal),
    ]
    
    static func createMemoryGame() -> MemoryGame<String>{
        let theme = themes[Int.random(in: 0..<themes.count)]
        let emojis = theme.cardContents.shuffled()[0..<theme.numberOfPairsOfCards]
        return MemoryGame<String>(theme: theme) { pairIndex in
            return emojis[pairIndex]
        }
    }

    static func addTheme(_ theme: MemoryGame<String>.Theme){
        themes.append(theme)
    }
    
    func newGame() {
        self.model = EmojiMemoryGame.createMemoryGame()
    }

    // publish changes to view when model variable is changed
    // Swift can detect changes in struct
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    // Getters for View
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    var theme: MemoryGame<String>.Theme {
        model.currentTheme
    }
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
//        objectWillChange.send() publish changes to view
    }
    
    func select(theme: MemoryGame<String>.Theme) {
        model.select(theme: theme)
    }
}
