//
//  EmojiMemoryGameView.swift
//  cs193p_hw6
//
//  Created by 鄭勝偉 on 2023/8/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
  @ObservedObject var game: EmojiMemoryGame

  var body: some View {
    VStack {
      Text("\(game.name) matching")
        .font(.title)
      ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
          ForEach(game.cards) { card in
            CardView(card: card)
              .aspectRatio(2 / 3, contentMode: .fit)
              .onTapGesture {
                game.choose(card)
              }
          }
        }
      }
      .bold()
      .padding(.horizontal)
      .font(.largeTitle)
      Spacer()
      VStack {
        VStack {
          Image(systemName: "gamecontroller.fill")
          Text("New game")
        }
        .bold()
        .onTapGesture {
          game.newGame()
        }
        Text("Current Score = \(game.currentScore)")
      }

    }.foregroundColor(game.color)
  }

  struct CardView: View {
    let card: MemoryGame<String>.Card

    var body: some View {
      GeometryReader{ geometry in
        ZStack(alignment: .center) {
          let shape = RoundedRectangle(cornerRadius: 25.0)
          if card.isFaceUp {
            shape.fill().foregroundColor(.white)
            shape.strokeBorder(lineWidth: 5)
            Text(card.content)
              .frame(width: geometry.size.width , height: geometry.size.height)
          }
          else {
            RoundedRectangle(cornerRadius: 25.0)
              .fill()
          }
        }
      }
    }
  }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
  static var previews: some View {
    let testgame = EmojiMemoryGame(palette: Palette(name: "sample", emojis: "🩷❤️🧡💛💚🩵💙💜🖤🩶", id: 69, color: Color(red: 1, green: 1, blue: 0)))
    EmojiMemoryGameView(game: testgame)
  }
}
