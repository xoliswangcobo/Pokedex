//
//  ListBackground.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/20.
//

import SwiftUI

struct ListBackground: ViewModifier {

    var color: Color
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .background(color)
            .scrollContentBackground(.hidden)
    }
}

extension View {
    
    func listBackground(_ colour: Color) -> some View {
        self.modifier(ListBackground(color: colour))
    }
}

