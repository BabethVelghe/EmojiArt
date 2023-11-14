//
//  EmojiArtDocu.swift
//  EmojiArt
//
//  Created by Babeth Velghe on 17/10/2023.
//
// viewmodel
// always class and ObservableObject
import SwiftUI

class EmojiArtDocu : ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt()
    
    init() {
        emojiArt.addEmoji("🦋", at: .init(x: -200, y: -150), size: 200)
        emojiArt.addEmoji("🐙", at: .init(x: 250, y: 100), size: 80)
    }
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var background: URL? {
        emojiArt.background
    }
    
    //MARK: - Intent(s)
    
    func setBackground( _ url: URL?) {
        emojiArt.background = url
    }
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
        emojiArt.addEmoji(emoji, at: position, size: Int(size))
    }
}

extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
    
}
extension EmojiArt.Emoji.Position {
    // if you want to use a reserved keyword you have to use single back qoutes
    func `in` (_ geometry: GeometryProxy) -> CGPoint {
        // .center --> extensions zelf toegevoegd
        let center = geometry.frame(in: .local).center
        // y is omgekeerd is - in plaats van +
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}
