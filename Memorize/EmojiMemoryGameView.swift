//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Sanjay Katta on 06/02/22.
//

import SwiftUI

// View

struct EmojiMemoryGameView: View {
    
    //something changed rebuild the body
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button {
                    game.newGame()
                } label: {
                    HStack{
                        Image(systemName: "plus.app")
                        Text("New Game")
                    }
                }
            }.padding()
            AspectVGrid(items: game.cards, aspectRatio: 2/3){ card in
                if card.isMatched && !card.isFaceUp {
                    Rectangle().opacity(0)
                } else {
                    CardView(card: card)
                        .padding(4)
                        .onTapGesture {
                            game.choose(card)
                        }
                }
            }
            HStack{
                Text("Score: \(game.score)")
                    .font(.title2)
                Spacer()
                Text("Theme: \(game.theme.name)")
                    .font(.footnote)
            }
            .padding()
        }
        .foregroundColor(game.theme.color)
        .padding(.horizontal)
    }
}

struct CardView: View {
    
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: Constants.lineWidth)
                    Pie(startAngle: .degrees(0-90), endAngle: .degrees(110-90))
                        .padding(5)
                        .opacity(0.40)
                    Text(card.content)
                        .font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * Constants.fontScale)
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.5
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
