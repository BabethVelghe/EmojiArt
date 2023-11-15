//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by Babeth Velghe on 15/11/2023.
//

import SwiftUI

struct PaletteManager: View {
    let stores: [PaletteStore]
    
    @State var selectedStore: PaletteStore?
    
    var body: some View {
        NavigationSplitView {
            List(stores, selection: $selectedStore) { store in
//              Text(store.name) // bad!!
                // this is "bad" because store is not an @ObservedObject in this View
                // instead, pass the store onto another View's @ObservedObject (as below)
                // this is not ACTUALLY a problem for PaletteStore's name var
                // because it's not @Published anyway (and furthermore is a let constant)
                // but be careful of this case where an ObservableObject
                // is passed to a View not via @ObservableObject or @EnvironmentObject
                // (it's passed to PaletteManager via an [PaletteStore])
                PaletteStoreView(store: store)
                // tag get stored in $selectedStore
                    .tag(store)
            }
        } content: {
            if let selectedStore {
                EditablePaletteListView(store: selectedStore)
            }
            Text("Choose a store")
        } detail: {
            Text("Choose a palette")
        }
    }
}

struct PaletteStoreView: View {
    @ObservedObject var store: PaletteStore
    
    var body: some View {
        Text(store.name)
    }
}

struct PaletteManager_Previews: PreviewProvider {
    static var previews: some View {
        PaletteManager(stores: [PaletteStore(named: "Preview1"),PaletteStore(named: "Preview2")])
    }
}
