//
//  DraggableCover.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct DraggableCover : View {
    
    // MARK: - Drag State
    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .pressing, .dragging:
                return true
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive, .pressing:
                return false
            case .dragging:
                return true
            }
        }
    }
    
    // MARK: - Internal vars
    @State private var viewState = CGSize.zero
    @EnvironmentObject private var state: AppState
    @GestureState private var dragState = DragState.inactive
    
    // MARK: - Internal consts
    private let minimumLongPressDuration = 0.1
    private let shadowSize: Length = 4
    private let shadowRadius: Length = 16
    
    // MARK: - Constructor vars
    let movieId: Int
    @Binding var draggedViewState: DragState
    
    // MARK: - Computed vars
    var movie: Movie! {
        state.moviesState.movies[movieId]
    }
    
    // MARK: - Viewd functions
    
    func computedOffset() -> CGSize {
        return CGSize(
            width: dragState.isActive ? viewState.width +  dragState.translation.width : 0,
            height: 0
        )
    }
    
    func computeAngle() -> Angle {
        Angle(degrees: Double(dragState.translation.width / 15))
    }
    
    // MARK: - View
    var body: some View {
        // MARK: - Gesture
        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: DragGesture())
            .updating($dragState) { value, state, transaction in
                switch value {
                case .first(true):
                    state = .pressing
                case .second(true, let drag):
                    state = .dragging(translation: drag?.translation ?? .zero)
                default:
                    state = .inactive
                }
            }.onChanged { value in
                self.draggedViewState = .dragging(translation: self.dragState.translation)
            }.onEnded { value in
                self.draggedViewState = .inactive
            }
        // MARK: - View return
        return DiscoverCoverImage(imageLoader: ImageLoader(poster: movie.poster_path,
                                                         size: .original))
            .offset(computedOffset())
            .rotationEffect(computeAngle())
            .scaleEffect(dragState.isActive ? 1.1: 1)
            .shadow(color: .secondary,
                    radius: dragState.isActive ? shadowRadius : 0,
                    x: dragState.isActive ? shadowSize : 0,
                    y: dragState.isActive ? shadowSize : 0)
            .animation(.fluidSpring())
            .gesture(longPressDrag)
    }
}

// MARK: - Preview
#if DEBUG
struct DraggableCover_Previews : PreviewProvider {
    static var previews: some View {
        DraggableCover(movieId: 0, draggedViewState: .constant(.inactive)).environmentObject(sampleStore)
    }
}
#endif
