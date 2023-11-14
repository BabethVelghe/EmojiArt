//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Babeth Velghe on 17/10/2023.
//
// model : background and emoji's the size and where they are

import Foundation
// error: EmojiArt can't be codable because not all vars are codable
// fix every struct has to be codable
struct EmojiArt : Codable {
    // this can be a problem because the internet can be slow
    var background: URL? = nil
    // wij kunnen enkel dingen gaan toevoegen in Emojis
    private (set) var emojis = [Emoji]()
    
    func json() throws -> Data {
        let encoded  = try JSONEncoder().encode(self)
        print("EmojiArt = \(String(data: encoded, encoding: .utf8) ?? "nil" )")
        return encoded
    }
    
    init(json : Data) throws {
        self = try JSONDecoder().decode(EmojiArt.self, from: json)
    }
    init() {
        
    }
    
    private var uniqueEmojiId = 0
    
    // Belangrijk omdat je unique id aanpast +  adding Emoji
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(
            string: emoji,
            position: position,
            size: size,
            id: uniqueEmojiId
        ))
    }
    
    //substruct
    struct Emoji : Identifiable, Codable {
        let string: String
        var position: Position
        var size: Int
        var id: Int
        
        //substruct
        struct Position : Codable {
            // why vars --> you want them to move
            var x: Int
            var y: Int
            //                Self
            static let zero = Position(x: 0, y: 0)
        }
        
    }
    
    
    
}

