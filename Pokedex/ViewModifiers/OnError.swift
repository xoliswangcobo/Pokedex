//
//  OnError.swift
//  Pokedex
//
//  Created by Xoliswa X on 2024/11/22.
//

import SwiftUI

fileprivate struct OnError: ViewModifier {
    
    @Binding var error: Error?
    @State var title: String
    var actions: [(String, (() -> Void)?)]?
    
    private var isShowing: Binding<Bool> {
        Binding {
            error != nil
        }
        set: { value in
            error = value ? error : nil
        }
    }
    
    func body(content: Content) -> some View {
            content
            .alert(title, isPresented: isShowing, actions: {
                ForEach(actions ?? [], id: \.0) { action in
                    Button(action.0) { action.1?() }
                }
            }, message: {
                if let message = error?.localizedDescription {
                    Text(message)
                }
            })
    }
}

extension View {
    func onError(error: Binding<Error?>, title: String = "", actions: [(String, (() -> Void)?)]? = nil) -> some View {
        modifier(OnError(error: error, title: title, actions: actions))
    }
}
