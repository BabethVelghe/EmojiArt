//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Babeth Velghe on 17/10/2023.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Main")

    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
                .environmentObject(paletteStore)
            // this is saying : there is this object PaletteStore and is injected in to all views
            
        }
    }
}
