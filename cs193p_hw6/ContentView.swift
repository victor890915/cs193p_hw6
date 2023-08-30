//
//  ContentView.swift
//  cs193p_hw6
//
//  Created by 鄭勝偉 on 2023/8/23.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var paletteStore: PaletteStore
 
//  var initPalette: Palette = Palette(name: "init" , emojis: "", id: -1, color: Color(red: 1, green: 0, blue: 0))
  
//  @StateObject var emojiMemoryGames = EmojiMemoryGameArray(initgames: [])
  
  static var emojiMemoryGames: [EmojiMemoryGame] = [EmojiMemoryGame(palette: Palette(name: "init", emojis: "", id: -1, color: Color(red: 1, green: 0, blue: 0)))]
    
  @State private var editMode: EditMode = .inactive
  
  @Environment(\.presentationMode) var presentationMode
  
  @State private var paletteToEdit: Palette?
//
//  func getGameView(for palette: Palette) -> some View {
//    if let game = emojiMemoryGames.games.first(where: { $0.palette.id == palette.id }) {
//      return EmojiMemoryGameView(game: game)
//    }
//    else {
//      emojiMemoryGames.addI(EmojiMemoryGame(palette: palette))
//      return EmojiMemoryGameView(game: emojiMemoryGames.games.last!)
//    }
//  }
//
  func getGameView(for palette: Palette) -> some View {
    if let game = ContentView.emojiMemoryGames.first(where: { $0.palette.id == palette.id }) {
      if game.palette == palette {
        print("same game")
        return EmojiMemoryGameView(game: game)
      }
      else {
        print("altered palette")
        let newGame = EmojiMemoryGame(palette: palette)
        let removeIndex = ContentView.emojiMemoryGames.firstIndex(where: { $0.palette.id == palette.id })
        ContentView.emojiMemoryGames.remove(at: removeIndex!)
        ContentView.emojiMemoryGames.append(newGame)
        return EmojiMemoryGameView(game: ContentView.emojiMemoryGames.last!)
      }
    }
    else {
      print("new game using chosen palette")
      ContentView.emojiMemoryGames.append(EmojiMemoryGame(palette: palette))
      return EmojiMemoryGameView(game: ContentView.emojiMemoryGames.last!)
    }
  }
  
  var body: some View {
    VStack {
      NavigationView {
        List {
          ForEach(paletteStore.palettes) { palette in
            NavigationLink(destination: getGameView(for: palette)) {
              VStack(alignment: .leading) {
                Text(palette.name)
                  .font(.largeTitle)
                  .foregroundColor(Color(rgbaColor: palette.color))
                Text(palette.emojis)
                Text("pairs of cards \(palette.pairs)")
              }
            }.gesture(editMode == .active ? tap(palette.id) : nil)
          }
          .onDelete { indexSet in
            paletteStore.palettes.remove(atOffsets: indexSet)
          }
        }
        .navigationTitle("Memorize Game")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button{
              paletteStore.insertPalette(named: "new palette", color: Color(red: 0, green: 0, blue: 0))
              paletteToEdit = paletteStore.palettes.first(where: {$0.name == "new palette"})
            } label: {
              Image(systemName: "plus")
            }
          }
          ToolbarItem { EditButton() }
        }
        .environment(\.editMode, $editMode)
      }
    }
    .popover(item: $paletteToEdit) { palette in
      PaletteEditor(palette: $paletteStore.palettes[palette])
    }
    .onAppear {
      ContentView.emojiMemoryGames.removeAll()
    }
  }
  
  private func tap(_ index: Int) -> some Gesture {
    return TapGesture().onEnded {
      if let id = paletteStore.palettes.first(where: { $0.id == index }) {
        paletteToEdit = paletteStore.palettes[id]
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let paletteStore = PaletteStore(named: "preview")
    ContentView()
      .environmentObject(paletteStore)
  }
}
