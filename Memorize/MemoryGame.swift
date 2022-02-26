//
//  MemoryGame.swift
//  Memorize
//
//  Created by Sanjay Katta on 15/02/22.
//

import SwiftUI

// Model

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    private(set) var score = 0
    
    private(set) var currentTheme: Theme
    
    mutating func choose(_ card: Card){
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }), !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else {
                    score -= 1
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    mutating func select(theme: Theme){
        self.currentTheme = theme
    }
    
    init(theme: Theme, createCardContent: (Int) -> CardContent){
        cards = []
        //add numberOfPairsOfCards x 2 cards to cards array
        for pairIndex in 0 ..< theme.numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards = cards.shuffled()
        self.currentTheme = theme
    }
    
    struct Theme {
        var name: String
        var cardContents: Array<CardContent>
        var numberOfPairsOfCards: Int
        var color: Color
        init(name: String, cardContents: Array<CardContent>, numberOfPairsOfCards: Int, color: Color){
            self.name = name
            self.cardContents = cardContents
            self.color = color
            if numberOfPairsOfCards > cardContents.count {
                self.numberOfPairsOfCards = cardContents.count
            } else {
                self.numberOfPairsOfCards = numberOfPairsOfCards
            }
        }
        init(name: String, cardContents: Array<CardContent>, color: Color){
            self.name = name
            self.cardContents = cardContents
            self.color = color
            self.numberOfPairsOfCards = cardContents.count
        }
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        let id: Int
    }
}
