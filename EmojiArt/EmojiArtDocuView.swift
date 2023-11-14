//
//  EmojiArtDocuView.swift
//  EmojiArt
//
//  Created by Babeth Velghe on 17/10/2023.
//

import SwiftUI

struct EmojiArtDocuView: View {
    
    @ObservedObject var document: EmojiArtDocu
    typealias Emoji = EmojiArt.Emoji
    
    private let paletteEmojiSize: CGFloat = 40
    
    private let emojis = "👻🍎😃🤪☹️🤯🐶🐭🦁🐵🦆🐝🐢🐄🐖🌲🌴🌵🍄🌞🌎🔥🌈🌧️🌨️☁️⛄️⛳️🚗🚙🚓🚲🛺🏍️🚘✈️🛩️🚀🚁🏰🏠❤️💤⛵️"
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            ScrollingEmojis(emojis)
                .font(.system(size: paletteEmojiSize))
                // .horizontal --> doet enkel de horizontale padding
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
        
    }
    private var documentBody : some View {
        // the geometry can tell you de size, but also the entire coordnate system of the view
        GeometryReader { geometry in
            
            ZStack {
                Color.white
                // We will write async code ourselfs 
                AsyncImage(url: document.background)
                    // Emoji.Position(x:0,y:0)
                    .position(Emoji.Position.zero.in(geometry))
                ForEach(document.emojis) { emoji in
                    Text(emoji.string)
                        .font(emoji.font)
                        .position(emoji.position.in(geometry))
                }
                
            }
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
        }
    }
    private func drop (_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
                case .url(let url) :
                    document.setBackground(url)
                    return true
                case .string(let emoji):
                    document.addEmoji(
                       emoji,
                       at: emojiPosition(at: location, in: geometry),
                        size: paletteEmojiSize)
                    return true
                default:
                    break
            }
            
        }
        return false
    }
    
    private func emojiPosition (at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(x: Int(location.x-center.x), y: Int(-location.y - center.y))
    }
}




struct ScrollingEmojis : View {
    // you can base a Number, Int with de string constructor because he is able to change it into a String
    let emojis: [String]
    // because you have String of all emojis
    init(_ emojis: String) {
        //            emojis.uniqued.map{ String($0)} --> is hetzelfde
        self.emojis = emojis.uniqued.map(String.init)
        
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            // we want een Array of strings, each string is one emoji
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}

#Preview {
    EmojiArtDocuView(document: EmojiArtDocu())
}
