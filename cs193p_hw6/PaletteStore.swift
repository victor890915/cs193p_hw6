//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/3/21.
//

import SwiftUI

// L11 a simple, persistent storage place for Palettes

struct Palette: Identifiable, Codable, Hashable {
  var name: String
  var emojis: String
  var id: Int
  var color: RGBAColor
  var pairs: Int{
    didSet{
      if self.pairs > emojis.count{
        self.pairs = emojis.count
      }
      if self.pairs < 1{
        self.pairs = 1
      }
    }
  }
    
//  fileprivate
  init(name: String, emojis: String, id: Int, color: Color) {
    self.name = name
    self.emojis = emojis
    self.id = id
    self.color = RGBAColor(color: color)
    self.pairs = emojis.count
  }
}

class PaletteStore: ObservableObject {
  let name: String
    
  @Published var palettes = [Palette]() {
    didSet {
      storeInUserDefaults()
    }
  }
    
  private var userDefaultsKey: String {
    "PaletteStore:" + name
  }
    
  private func storeInUserDefaults() {
    UserDefaults.standard.set(try? JSONEncoder().encode(palettes), forKey: userDefaultsKey)
  }
    
  private func restoreFromUserDefaults() {
    if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
       let decodedPalettes = try? JSONDecoder().decode([Palette].self, from: jsonData)
    {
      palettes = decodedPalettes
    }
  }
    
  init(named name: String) {
    self.name = name
    restoreFromUserDefaults()
    if palettes.isEmpty {
      insertPalette(named: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜", color: Color(red: 1, green: 0, blue: 0))
      insertPalette(named: "Sports", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳", color: Color(red: 1, green: 1, blue: 0))
      insertPalette(named: "Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻", color: Color(red: 1, green: 0, blue: 1))
      insertPalette(named: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔", color: Color(red: 0, green: 1, blue: 1))
      insertPalette(named: "Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲", color: Color(red: 0, green: 0, blue: 1.0))
      insertPalette(named: "Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻", color: Color(red: 0, green: 1, blue: 0))
      insertPalette(named: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪", color: Color(red: 0.4627, green: 0.8, blue: 0.3))
      insertPalette(named: "COVID", emojis: "💉🦠😷🤧🤒", color: Color(red: 0.42, green: 0.5392, blue: 1))
      insertPalette(named: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠", color: Color(red: 0.4627, green: 0.8392, blue: 1.0))
    }
  }
    
  // MARK: - Intent
    
  func palette(at index: Int) -> Palette {
    let safeIndex = min(max(index, 0), palettes.count - 1)
    return palettes[safeIndex]
  }
    
  @discardableResult
  func removePalette(at index: Int) -> Int {
    if palettes.count > 1, palettes.indices.contains(index) {
      palettes.remove(at: index)
    }
    return index % palettes.count
  }
    
  func insertPalette(named name: String, emojis: String? = nil, at index: Int = 0, color: Color) {
    let unique = (palettes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
    let palette = Palette(name: name, emojis: emojis ?? "", id: unique, color: color)
    let safeIndex = min(max(index, 0), palettes.count)
    palettes.insert(palette, at: safeIndex)
  }
}

struct RGBAColor: Codable, Equatable, Hashable {
 let red: Double
 let green: Double
 let blue: Double
 let alpha: Double
}

extension Color {
 init(rgbaColor rgba: RGBAColor) {
 self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
 }
}

extension RGBAColor {
 init(color: Color) {
 var red: CGFloat = 0
 var green: CGFloat = 0
 var blue: CGFloat = 0
 var alpha: CGFloat = 0
 if let cgColor = color.cgColor {
 UIColor(cgColor: cgColor).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
 }
 self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
 }
}
