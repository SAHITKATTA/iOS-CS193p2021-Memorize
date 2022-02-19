//
//  ContentView.swift
//  Memorize
//
//  Created by Sanjay Katta on 06/02/22.
//

import SwiftUI

// View

struct ContentView: View {
    
    //something changed rebuild the body
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                        }
                    }
                }
            }
            .foregroundColor(.red)
            .padding(.horizontal)
    }
}

struct CardView: View {
    
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content)
                    .font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        Group {
            ContentView(viewModel: game)
                .previewDevice("iPhone 13 Pro Max")
            ContentView(viewModel: game)
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 8 Plus")

        }
    }
}
