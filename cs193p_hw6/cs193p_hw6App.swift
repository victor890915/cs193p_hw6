//
//  cs193p_hw6App.swift
//  cs193p_hw6
//
//  Created by 鄭勝偉 on 2023/8/23.
//

import SwiftUI

@main
struct cs193p_hw6App: App {
  
  @StateObject var paletteStore = PaletteStore(named: "Default")
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(paletteStore)
        }
    }
}
