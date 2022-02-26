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
    
    typealias Card = MemoryGame<String>.Card
    typealias Theme = MemoryGame<String>.Theme

    private static var themes = [
        Theme(name: "Vehicles", cardContents:  "🛥🚀✈️🚇🚡🚘🛺🛵🚲🚜🚛🚓🚗🚑🚙🏎🚂🛩🛸🚁🚢".toStringArray(), numberOfPairsOfCards: 5, color: .red),
        Theme(name: "Expressions", cardContents:  "😀😆🤣😂😊😇🙂😉🙃😌😜🧐😎😒😔".toStringArray(), numberOfPairsOfCards: 6, color: .blue),
        Theme(name: "Animals", cardContents:  "🐶🐱🐭🐹🐰🦊🐻🐼🐯🦁🐷🐸🐵🐧🐤🐣🦅🦇🦋".toStringArray(), numberOfPairsOfCards: 7, color: .yellow),
        Theme(name: "Food", cardContents:  "🍎🍉🍒🍓🍈🍑🍅🥝🍆🥑🥬🌽🌶🥕🥯🧀🥞🥩🧇🍗🍔🍟🍕".toStringArray(), numberOfPairsOfCards: 8, color: .orange),
        Theme(name: "Apple", cardContents:  "⌚️📱💻⌨️🖥🖱🎧👨‍💻".toStringArray(), color: .gray),
        Theme(name: "Music", cardContents:  "🎶🎼🎵🎤🎸🎧🥁🎹🎺🎻🎷🪗🪘🪕".toStringArray(), numberOfPairsOfCards: 10, color: .teal),
    ]
    
    private static func createMemoryGame() -> MemoryGame<String>{
        let theme = themes[Int.random(in: 0..<themes.count)]
        let emojis = theme.cardContents.shuffled()[0..<theme.numberOfPairsOfCards]
        return MemoryGame<String>(theme: theme) { pairIndex in
            return emojis[pairIndex]
        }
    }

    static func addTheme(_ theme: Theme){
        themes.append(theme)
    }
    
    func newGame() {
        self.model = EmojiMemoryGame.createMemoryGame()
    }

    // publish changes to view when model variable is changed
    // Swift can detect changes in struct
    @Published private var model = createMemoryGame()
    
    // Getters for View
    var cards: Array<Card> {
        model.cards
    }
    var theme: Theme {
        model.currentTheme
    }
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
//        objectWillChange.send() publish changes to view
    }
    
    func select(theme: Theme) {
        model.select(theme: theme)
    }
}
