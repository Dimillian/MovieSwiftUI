//
//  DraggableCover.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Backend

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
            case .dragging(let translation, _):
                return translation
            }
        }
        
        var predictedLocation: CGPoint {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(_, let predictedLocation):
                return predictedLocation
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
    @State private var predictedEndLocation: CGPoint? = nil
    @State private var hasMoved = false
    @State private var delayedIsActive = false
    @EnvironmentObject private var store: Store<AppState>
    @GestureState private var dragState = DragState.inactive
    private let hapticFeedback = UISelectionFeedbackGenerator()
    
    // MARK: - Internal consts
    private let minimumLongPressDuration = 0.01
    private let shadowSize: CGFloat = 4
    private let shadowRadius: CGFloat = 16
    
    // MARK: - Constructor vars
    let movieId: Int
    @Binding var gestureViewState: DragState
    let onTapGesture: () -> Void
    let willEndGesture: (CGSize) -> Void
    let endGestureHandler: (EndState) -> Void
    
    // MARK: - Computed vars
    private var movie: Movie! {
        store.state.moviesState.movies[movieId]
    }
    
    // MARK: - Viewd functions
    
    private func computedOffset() -> CGSize {
        if let location = predictedEndLocation {
            return CGSize(width: location.x,
                          height: 0)
        }
        
        return CGSize(
            width: dragState.isActive ? dragState.translation.width : 0,
            height: 0
        )
    }
    
    private func computeAngle() -> Angle {
        if let location = predictedEndLocation {
            return Angle(degrees: Double(location.x / 15))
        }
        return Angle(degrees: Double(dragState.translation.width / 15))
    }
    
    private var coverSpringAnimation: Animation {
        .interpolatingSpring(mass: 1, stiffness: 150, damping: 15, initialVelocity: 5)
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
                    self.hapticFeedback.selectionChanged()
                case .second(true, let drag):
                    state = .dragging(translation: drag?.translation ?? .zero, predictedLocation: drag?.predictedEndLocation ?? .zero)
                default:
                    state = .inactive
                }
            }.onChanged { value in
                self.delayedIsActive = true
                if self.dragState.translation.width == 0.0 {
                    self.hasMoved = false
                    self.gestureViewState = .pressing
                } else {
                    self.hasMoved = true
                    self.gestureViewState = .dragging(translation: self.dragState.translation,
                                                      predictedLocation: self.dragState.predictedLocation)
                }
            }.onEnded { value in
                let endLocation = self.gestureViewState.predictedLocation
                if endLocation.x < -150 {
                    self.predictedEndLocation = endLocation
                    self.willEndGesture(self.gestureViewState.translation)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.endGestureHandler(.left)
                    }
                } else if endLocation.x > UIScreen.main.bounds.width - 50 {
                    self.predictedEndLocation = endLocation
                    self.willEndGesture(self.gestureViewState.translation)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.endGestureHandler(.right)
                    }
                } else {
                    self.endGestureHandler(.cancelled)
                }
                self.gestureViewState = .inactive
            }
        
        // MARK: - View return
        return DiscoverCoverImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: movie.poster_path,
                                                                                 size: .medium))
            .offset(computedOffset())
            .animation(delayedIsActive ? coverSpringAnimation : nil)
            .opacity(predictedEndLocation != nil ? 0 : 1)
            .rotationEffect(computeAngle())
            .scaleEffect(dragState.isActive ? 1.03: 1)
            .shadow(color: .secondary,
                    radius: dragState.isActive ? shadowRadius : 0,
                    x: dragState.isActive ? shadowSize : 0,
                    y: dragState.isActive ? shadowSize : 0)
            .animation(coverSpringAnimation)
            .gesture(longPressDrag)
            .simultaneousGesture(TapGesture(count: 1).onEnded({ _ in
                if !self.hasMoved {
                    self.onTapGesture()
                }
            }))
            .onAppear{
                self.hapticFeedback.prepare()
        }
    }
}

// MARK: - Preview
#if DEBUG
struct DraggableCover_Previews : PreviewProvider {
    static var previews: some View {
        DraggableCover(movieId: 0,
                       gestureViewState: .constant(.inactive),
                       onTapGesture: {
                        
        },
                       willEndGesture: { _ in
                        
        },
                       endGestureHandler: {handler in
            
        }).environmentObject(sampleStore)
    }
}
#endif
