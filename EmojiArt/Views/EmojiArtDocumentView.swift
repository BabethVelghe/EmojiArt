//
//  EmojiArtDocumentView.swift
//  Emoji Art
//
//  Created by CS193p Instructor on 5/8/23.
//  Copyright (c) 2023 Stanford University
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    
    @ObservedObject var document: EmojiArtDocument
    
    private let emojis = "👻🍎😃🤪☹️🤯🐶🐭🦁🐵🦆🐝🐢🐄🐖🌲🌴🌵🍄🌞🌎🔥🌈🌧️🌨️☁️⛄️⛳️🚗🚙🚓🚲🛺🏍️🚘✈️🛩️🚀🚁🏰🏠❤️💤⛵️"
    
    private let paletteEmojiSize: CGFloat = 40

    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooserView()
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom) // may scale effect is not just te zoom but is that times what every the gesture is
                    .offset(pan + gesturePan)
            }
            // to have both of the gestures to be recognize
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
        }
    }
    
  // zoom and pin arround documentContents , CGSize is a CGOffset
    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero
    
    @GestureState private var gestureZoom: CGFloat = 1
    @GestureState private var gesturePan: CGOffset = .zero
    
    // in this case it wil be on the Zstack
    private var zoomGesture : some Gesture {
        MagnificationGesture()
        // to see something will dragging
            .updating($gestureZoom) { inMotionPinchScale, gestureZoom, _ in
                // zoom += inMotionPinchScale // gives a runtime error
                gestureZoom = inMotionPinchScale
            }
            .onEnded{ endingPinchScale in
                zoom *= endingPinchScale
            }
        
    }
    
    //when you want to drag one individual emoji you have to think on what you want to put the gesture
    private var panGesture: some Gesture {
        DragGesture()
            .updating($gesturePan) { value , gesturePan, _ in
                gesturePan = value.translation
            }
            .onEnded{ value in
                pan += value.translation
            }
    }
    
    @ViewBuilder
    private func documentContents (in geometry : GeometryProxy) -> some View {
        // what gets dragged and pinched --> content of our documents (background and emoji's
        AsyncImage(url: document.background) { phase in
            // handeling error if image drop doesn't work
            if let image = phase.image {
                image
            } else if let url = document.background {
                if phase.error != nil {
                    Text("\(url)")
                } else  {
                    ProgressView() // spinning thing
                }
            }
        }
        
            .position(Emoji.Position.zero.in(geometry))
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .position(emoji.position.in(geometry))
        }
    }
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(
                    emoji,
                    at: emojiPosition(at: location, in: geometry),
                    // controlling the size of your emojis 
                    size: paletteEmojiSize / zoom
                )
                return true
            default:
                break
            }
        }
        return false
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(
            x: Int((location.x - center.x - pan.width) / zoom),
            y: Int(-(location.y - center.y - pan.height) / zoom)
        )
    }
}


struct EmojiArtDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
            .environmentObject(PaletteStore(named: "preview"))
    }
}
