//
//  EmojiArtDocuView.swift
//  EmojiArt
//
//  Created by Babeth Velghe on 17/10/2023.
//

import SwiftUI

struct EmojiArtDocuView: View {
    
    private let emojis = "👻🍎😃🤪☹️🤯🐶🐭🦁🐵🦆🐝🐢🐄🐖🌲🌴🌵🍄🌞🌎🔥🌈🌧️🌨️☁️⛄️⛳️🚗🚙🚓🚲🛺🏍️🚘✈️🛩️🚀🚁🏰🏠❤️💤⛵️"
    
    var body: some View {
        VStack {
            Color.yellow
            ScrollingEmojis()
        }
    }
}

struct ScrollingEmojis : View {
    let emojis: [String]
    // because you have String of all emojis
    init(emojis: String) {
        self.emojis = emojis.
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            // we want een Array of strings, each string is one emoji
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                }
            }
        }
    }
}

#Preview {
    EmojiArtDocuView()
}
