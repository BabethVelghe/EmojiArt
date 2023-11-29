//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Babeth Velghe on 17/10/2023.
//

import SwiftUI

@main
struct EmojiArtApp: App {

    var body: some Scene {
        DocumentGroup(newDocument: { EmojiArtDocument() }) { config in
            EmojiArtDocumentView(document: config.document)
        }
    }

}
