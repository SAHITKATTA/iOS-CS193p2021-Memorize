//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Sanjay Katta on 06/02/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
