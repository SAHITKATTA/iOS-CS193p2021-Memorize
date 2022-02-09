//
//  ContentView.swift
//  Memorize
//
//  Created by Sanjay Katta on 06/02/22.
//

import SwiftUI

struct Theme: Identifiable, Hashable {
    let id: Int
    let label: String
    let emojis: [String]
    let color: Color
    let icon: String
    
}

struct ContentView: View {
    var themes: [Theme] {
        [
            Theme(id: 0, label: "Vehicles", emojis: ["🛥","🚀","✈️","🚇","🚡","🚘","🛺","🛵","🚲","🚜","🚛","🚓","🚗","🚑","🚙","🏎","🚂","🛩","🛸","🚁","🚢"], color: .red, icon: "car"),
            Theme(id: 1, label: "Sports", emojis: ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉","🥏","🎱","🪀","🏓","🏸","🏒","🏑","🥍","🏏","🪃"], color: .blue, icon: "sportscourt"),
            Theme(id: 2, label: "Apple", emojis: ["⌚️","📱","💻","⌨️","🖥","🖱","🎧","👨‍💻","👩‍💻"], color: .gray, icon: "applelogo")
        ]
    }
    @State var themeSelected = 0
    @State var emojisCount = 6
    
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    
                    let themeEmojis = themes[themeSelected].emojis
                    ForEach(themeEmojis[0...Int.random(in: 8..<themeEmojis.count)].shuffled(), id: \.self) { emoji in
                        CardView(content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(themes[themeSelected].color)
            Spacer()
            HStack{
                Spacer()
                ForEach(themes, id: \.self){ theme in
                    Button {
                        themeSelected = theme.id
                    } label: {
                        VStack{
                            Image(systemName: theme.icon)
                                .font(.largeTitle)
                            Text(theme.label)
                                .font(.caption)
                        }
                    }
                    Spacer()
                }
                
            }

        }
        .padding(.horizontal)
        
    }
}



struct CardView: View {
    var content: String
    @State var isFaceUp: Bool = true
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content)
                    .font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 13 Pro Max")
            ContentView()
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 8 Plus")

        }
    }
}
