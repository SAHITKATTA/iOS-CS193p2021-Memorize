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
                Pie(startAngle: .degrees(0-90), endAngle: .degrees(110-90))
                    .padding(5)
                    .opacity(0.40)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                //implicit animation
                    .animation(
                        .linear(duration: 1).repeatForever(autoreverses: false),
                        value: card.isMatched)
                    .font(Font.system(size: Constants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp, isMatched: card.isMatched)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / ( Constants.fontSize / Constants.fontScale )
    }

    private struct Constants {
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
