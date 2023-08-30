//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/5/21.
//

import SwiftUI

// L12 a View which edits the info in a bound-to Palette

struct PaletteEditor: View {
  
  @Binding var palette: Palette

  
  var body: some View {
    Form {
      nameSection
      addEmojisSection
      removeEmojiSection
      colorSelectionSection
      pairsSelection
    }
    .navigationTitle("Edit \(palette.name)")
    .frame(minWidth: 300, minHeight: 350)
  }
  
  var nameSection: some View {
    Section(header: Text("Theme Name")) {
      TextField("Name", text: $palette.name)
    }
  }
  
  @State private var emojisToAdd = ""
  var addEmojisSection: some View {
    Section(header: Text("Add Emojis")) {
      TextField("", text: $emojisToAdd)
        .onChange(of: emojisToAdd) { emojis in
          addEmojis(emojis)
        }
    }
  }
  
  func addEmojis(_ emojis: String) {
    withAnimation {
      palette.emojis = (emojis + palette.emojis)
        .filter { $0.isEmoji }
        .removingDuplicateCharacters
    }
  }
  
  var removeEmojiSection: some View {
    Section(header: Text("Remove Emoji")) {
      let emojis = palette.emojis.removingDuplicateCharacters.map { String($0) }
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
        ForEach(emojis, id: \.self) { emoji in
          Text(emoji)
            .onTapGesture {
              withAnimation {
                palette.emojis.removeAll(where: { String($0) == emoji })
              }
            }
        }
      }
      .font(.system(size: 40))
    }
  }
  

  @State var themeColor: Color = Color.black
  
  var colorSelectionSection: some View {
    Section(header: Text("Theme color")) {
      HStack{
        Text("Current Color :")
        RoundedRectangle(cornerRadius: 10)
          .fill()
          .foregroundColor(Color(red: palette.color.red, green: palette.color.green, blue: palette.color.blue))
          .frame(width: 50, height: 50)
        Spacer()
        ColorPicker("pick theme color", selection: $themeColor)
          .onChange(of: themeColor){ themeColor in
            palette.color = RGBAColor(color: themeColor)
          }
      }
    }
  }
  
  @State var pairsOfThisPalette: Int = 0
  var pairsSelection: some View{
    Section(header: Text("Number of pairs")){
      TextField("pairs of cards", value: $palette.pairs, format: .number)
    }
  }
  
  
  
}

struct PaletteEditor_Previews: PreviewProvider {
  static var previews: some View {
    PaletteEditor(palette: .constant(PaletteStore(named: "Preview").palette(at: 4)))
      .previewLayout(.fixed(width: 300, height: 350))
  }
}
