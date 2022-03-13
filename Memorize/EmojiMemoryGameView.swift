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
    
    @State private var dealt = Set<Int>()
    
    @Namespace private var dealingNamespace;
    
    var body: some View {
        VStack {
            header
            ZStack(alignment: .bottom) {
                gameBody
                deckBody
            }
            footer
        }
        .foregroundColor(game.theme.color)
        .padding(.horizontal)
    }
    var header: some View {
        HStack{
            Spacer()
            Button {
                withAnimation {
                    dealt = []
                    game.newGame()
                }
            } label: {
                HStack{
                    Image(systemName: "plus.app")
                    Text("New Game")
                }
            }
        }.padding()
    }
    
    private func deal(_ card: EmojiMemoryGame.Card){
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealtDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealtDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id}) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio){ card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(
                        AnyTransition.asymmetric(insertion: .identity, removal: .opacity)
                    )
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(
                        AnyTransition.asymmetric(insertion: .opacity, removal: .scale)
                    )
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var footer: some View {
        HStack{
            Text("Score: \(game.score)")
                .font(.title2)
            Spacer()
            Button {
                // Explicit Animation : usually used with intent funcs
                withAnimation {
                    game.shuffle()
                }
            } label: {
                HStack{
                    Image(systemName: "shuffle")
                    Text("Shuffle")
                }
            }
            Spacer()
            Text("Theme: \(game.theme.name)")
                .font(.footnote)
        }
        .padding()
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealtDuration: Double = 0.5
        static let totalDealtDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
}

struct CardView: View {
    
    let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: .degrees(0-90), endAngle: .degrees((1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: .degrees(0-90), endAngle: .degrees((1-card.bonusRemaining)*360-90))
                    }
                }
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
            .cardify(isFaceUp: card.isFaceUp)
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
