//
//  BottomMenu.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 05/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct BottomMenu<Content>: View where Content: View {
    
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        var isDragging: Bool {
            switch self {
            case .inactive:
                return false
            case .dragging:
                return true
            }
        }
    }
    
    var isPresented: Binding<Bool>
    let content: () -> Content
    let onDismiss: () -> Void
    var defaultHeight: CGFloat = 150
    
    @GestureState private var dragState = DragState.inactive
    
    init(isPresented: Binding<Bool>,
         onDismiss: @escaping () -> Void,
         @ViewBuilder content: @escaping () -> Content){
        self.content = content
        self.isPresented = isPresented
        self.onDismiss = onDismiss
    }
    
    func currentYOffset(geometry: GeometryProxy) -> CGFloat {
        if isPresented.wrappedValue && dragState.isDragging {
            return geometry.frame(in: .local).maxY - defaultHeight + dragState.translation.height * 0.5
        } else if isPresented.wrappedValue {
            return geometry.frame(in: .local).maxY - defaultHeight
        }
        return geometry.frame(in: .local).maxY + defaultHeight
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                VStack {
                    self.content()
                }
            }
            .background(Color.steam_background)
            .cornerRadius(10)
            .offset(x: 0, y: self.currentYOffset(geometry: geometry))
                .gesture(DragGesture().updating(self.$dragState) { drag, state, transaction in
                    state = .dragging(translation: drag.translation)
                }.onEnded { drag in
                    if drag.predictedEndLocation.y > geometry.frame(in: .global).maxY {
                        self.onDismiss()
                    }
                })
            .animation(.spring())
        }
    }

}

#if DEBUG
struct BottomMenu_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ZStack(alignment: .center) {
                    Text("My view wow")
                    BottomMenu(isPresented: .constant(true), onDismiss: {
                        
                    }) {
                        VStack {
                            Text("Item 1")
                            Text("Item 2")
                        }
                    }
                }
            }.previewDevice("iPhone 8")
              .environment(\.colorScheme, .dark)
            
            NavigationView {
                ZStack(alignment: .center) {
                    Text("My view wow")
                    BottomMenu(isPresented: .constant(false), onDismiss: {
                        
                    }) {
                        VStack {
                            Text("Item 1")
                            Text("Item 2")
                        }
                    }
                }
            }.previewDevice("iPhone 8")
        }
    }
}
#endif
