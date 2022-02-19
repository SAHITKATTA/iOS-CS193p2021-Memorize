//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Sanjay Katta on 06/02/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
