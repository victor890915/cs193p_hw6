//
//  EmojiMemoryGameArray.swift
//  cs193p_hw6
//
//  Created by 鄭勝偉 on 2023/8/30.
//

import Foundation

class EmojiMemoryGameArray: ObservableObject{
  @Published var games: [EmojiMemoryGame] = []
  
  init(initgames: [EmojiMemoryGame]) {
        self.games = initgames
    }
    
    func addI(_ item: EmojiMemoryGame) {
        games.append(item)
    }
}
