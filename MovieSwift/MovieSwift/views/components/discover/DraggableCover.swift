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
        case dragging(translation: CGSize, predictedLocation: CGPoint)
        
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let data):
                return data.translation
            }
        }
        
        var predictedLocation: CGPoint {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let data):
                return data.predictedLocation
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
    
    enum EndState {
        case left, right, cancelled
    }
    
    // MARK: - Internal vars
    @State private var viewState = CGSize.zero
    @EnvironmentObject private var store: AppStore
    @GestureState private var dragState = DragState.inactive
    
    // MARK: - Internal consts
    private let minimumLongPressDuration = 0.01
    private let shadowSize: Length = 4
    private let shadowRadius: Length = 16
    
    // MARK: - Constructor vars
    let movieId: Int
    @Binding var gestureViewState: DragState
    let endGestureHandler: (EndState) -> Void
    
    // MARK: - Computed vars
    var movie: Movie! {
        store.state.moviesState.movies[movieId]
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
                    state = .dragging(translation: drag?.translation ?? .zero, predictedLocation: drag?.predictedEndLocation ?? .zero)
                default:
                    state = .inactive
                }
            }.onChanged { value in
                if self.dragState.translation.width == 0.0 {
                    self.gestureViewState = .pressing
                } else {
                    self.gestureViewState = .dragging(translation: self.dragState.translation,
                                                      predictedLocation: self.dragState.predictedLocation)
                }
            }.onEnded { value in
                let endLocation = self.gestureViewState.predictedLocation
                if endLocation.x < -50 {
                    self.endGestureHandler(.left)
                } else if endLocation.x > UIScreen.main.bounds.width - 100 {
                    self.endGestureHandler(.right)
                } else {
                    self.endGestureHandler(.cancelled)
                }
                self.gestureViewState = .inactive
            }
        // MARK: - View return
        return DiscoverCoverImage(imageLoader: ImageLoader(poster: movie.poster_path,
                                                         size: .small))
            .offset(computedOffset())
            .rotationEffect(computeAngle())
            .scaleEffect(dragState.isActive ? 1.03: 1)
            .shadow(color: .secondary,
                    radius: dragState.isActive ? shadowRadius : 0,
                    x: dragState.isActive ? shadowSize : 0,
                    y: dragState.isActive ? shadowSize : 0)
            .animation(.fluidSpring(stiffness: 80,
                                    dampingFraction: 0.7,
                                    blendDuration: 0,
                                    timestep: 1.0 / 300,
                                    idleThreshold: 0.5))
            .gesture(longPressDrag)
    }
}

// MARK: - Preview
#if DEBUG
struct DraggableCover_Previews : PreviewProvider {
    static var previews: some View {
        DraggableCover(movieId: 0, gestureViewState: .constant(.inactive), endGestureHandler: {handler in
            
        }).environmentObject(sampleStore)
    }
}
#endif
