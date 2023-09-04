//
//  EmojiMemoryGame.swift
//  Memorize_ch5
//
//  Created by 鄭勝偉 on 2023/7/13.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
//  var palette = Palette(name: "sample", emojis: "🩷❤️🧡💛💚🩵💙💜🖤🩶", id: 69, color: Color(red: 1, green: 1, blue: 0))
  
  var palette: Palette
  var name: String
  var emojis: String
  var id: Int
  var color: Color
  
  var cards: [MemoryGame<String>.Card] {
    return model.cards
  }
    
  var currentScore: Int {
    return model.scoreOfGame
  }
  
  @Published private var model: MemoryGame<String>
  
  init(palette: Palette){
    self.palette = palette
    self.name = palette.name
    self.emojis = palette.emojis
    self.id = palette.id
    self.color = Color(rgbaColor: palette.color)
    self.model = MemoryGame<String>(numberOfPairsOfCards: min(palette.pairs,palette.emojis.count)) { pairIndex in
      let index = palette.emojis.index(palette.emojis.startIndex, offsetBy: pairIndex)
      return String(palette.emojis[index])
    }
  }

    
  // MARK: - Intent(s)
  
  func createMemoryGame() -> MemoryGame<String> {
    MemoryGame<String>(numberOfPairsOfCards: palette.pairs) { pairIndex in
      let index = palette.emojis.index(palette.emojis.startIndex, offsetBy: pairIndex)
      return String(palette.emojis[index])
    }
  }

  func choose(_ card: MemoryGame<String>.Card) {
//        objectWillChange.send() @published takes care of this line
    model.choose(card)
  }
    
  func newGame() {
    model = createMemoryGame()
  }
}
