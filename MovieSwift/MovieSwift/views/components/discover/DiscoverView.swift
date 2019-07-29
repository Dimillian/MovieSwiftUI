//
//  DiscoverView.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct DiscoverView : View {
    
    // MARk: - State vars
    
    @EnvironmentObject private var store: Store<AppState>
    
    @State private var draggedViewState = DraggableCover.DragState.inactive
    @State private var previousMovie: Int? = nil
    @State private var isFilterFormPresented = false
    @State private var presentedMovieId: Int? = nil
    @State private var willEndPosition: CGSize? = nil
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .soft)
    
    #if targetEnvironment(macCatalyst)
    private let bottomSafeInsetFix: CGFloat = 100
    #else
    private let bottomSafeInsetFix: CGFloat = 20
    #endif
    
    // MARK: - Computed properties
    
    private var movies: [Int] {
        store.state.moviesState.discover
    }
    
    private var filter: DiscoverFilter? {
        store.state.moviesState.discoverFilter
    }
    
    private var currentMovie: Movie? {
        guard !movies.isEmpty else {
            return nil
        }
        return store.state.moviesState.movies[movies.reversed()[0]]
    }
    
    private func scaleResistance() -> Double {
        Double(abs(willEndPosition?.width ?? draggedViewState.translation.width) / 6800)
    }
    
    private func dragResistance() -> CGFloat {
        abs(willEndPosition?.width ?? draggedViewState.translation.width) / 12
    }
    
    private func leftZoneResistance() -> CGFloat {
        -draggedViewState.translation.width / 1000
    }
    
    private func rightZoneResistance() -> CGFloat {
        draggedViewState.translation.width / 1000
    }
    
    private func draggableCoverEndGestureHandler(handler: DraggableCover.EndState) {
        guard let currentMovie = currentMovie else {
            return
        }
        if handler == .left || handler == .right {
            previousMovie = currentMovie.id
            if handler == .left {
                hapticFeedback.impactOccurred(intensity: 0.8)
                store.dispatch(action: MoviesActions.AddToWishlist(movie: currentMovie.id))
            } else if handler == .right {
                hapticFeedback.impactOccurred(intensity: 0.8)
                store.dispatch(action: MoviesActions.AddToSeenList(movie: currentMovie.id))
            }
            store.dispatch(action: MoviesActions.PopRandromDiscover())
            willEndPosition = nil
            fetchRandomMovies(force: false, filter: self.filter)
        }
    }
    
    private func fetchRandomMovies(force: Bool, filter: DiscoverFilter?) {
        if movies.count < 10 || force {
            store.dispatch(action: MoviesActions.FetchRandomDiscover(filter: filter))
        }
    }
    
    // MARK: Body views
    private var filterView: some View {
        return BorderedButton(text: filter?.toText(state: store.state) ?? "Loading...",
                              systemImageName: "line.horizontal.3.decrease",
                              color: .steam_blue,
                              isOn: false) {
                                self.isFilterFormPresented = true
        }
    }
    
    private var actionsButtons: some View {
        ZStack(alignment: .center) {
            if self.currentMovie != nil {
                Text(self.currentMovie!.userTitle)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .font(.FjallaOne(size: 18))
                    .lineLimit(2)
                    .opacity(self.draggedViewState.isDragging ? 0.0 : 1.0)
                    .offset(x: 0, y: -15)
                    .animation(.easeInOut)
                
                Circle()
                    .strokeBorder(Color.pink, lineWidth: 1)
                    .background(Image(systemName: "heart.fill").foregroundColor(.pink))
                    .frame(width: 50, height: 50)
                    .offset(x: -70, y: 0)
                    .opacity(self.draggedViewState.isDragging ? 0.3 + Double(self.leftZoneResistance()) : 0)
                    .animation(.spring())
                
                Circle()
                    .strokeBorder(Color.green, lineWidth: 1)
                    .background(Image(systemName: "eye.fill").foregroundColor(.green))
                    .frame(width: 50, height: 50)
                    .offset(x: 70, y: 0)
                    .opacity(self.draggedViewState.isDragging ? 0.3 + Double(self.rightZoneResistance()) : 0)
                    .animation(.spring())
                
                
                Circle()
                    .strokeBorder(Color.red, lineWidth: 1)
                    .background(Image(systemName: "xmark").foregroundColor(.red))
                    .frame(width: 50, height: 50)
                    .offset(x: 0, y: 30)
                    .opacity(self.draggedViewState.isDragging ? 0.0 : 1)
                    .animation(.spring())
                    .onTapGesture {
                        self.hapticFeedback.impactOccurred(intensity: 0.5)
                        self.previousMovie = self.currentMovie!.id
                        self.store.dispatch(action: MoviesActions.PopRandromDiscover())
                        self.fetchRandomMovies(force: false, filter: self.filter)
                }
                
                Button(action: {
                    self.store.dispatch(action: MoviesActions.PushRandomDiscover(movie: self.previousMovie!))
                    self.previousMovie = nil
                }, label: {
                    Image(systemName: "gobackward").foregroundColor(.steam_blue)
                }) .frame(width: 50, height: 50)
                    .offset(x: -60, y: 30)
                    .opacity(self.previousMovie != nil && !self.draggedViewState.isActive ? 1 : 0)
                    .animation(.spring())
                
                Button(action: {
                    self.store.dispatch(action: MoviesActions.ResetRandomDiscover())
                    self.fetchRandomMovies(force: true, filter: nil)
                }, label: {
                    Image(systemName: "arrow.swap")
                        .foregroundColor(.steam_blue)
                })
                    .frame(width: 50, height: 50)
                    .offset(x: 60, y: 30)
                    .opacity(self.draggedViewState.isDragging ? 0.0 : 1.0)
                    .animation(.spring())
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { reader in
                self.filterView
                    .position(x: reader.frame(in: .local).midX, y: 30)
                    .frame(height: 50)
            }
            ForEach(movies, id: \.self) { id in
                Group {
                    if self.movies.reversed().firstIndex(of: id) == 0 {
                        DraggableCover(movieId: id,
                                       gestureViewState: self.$draggedViewState,
                                       onTapGesture: {
                                        self.presentedMovieId = self.currentMovie?.id
                        },
                                       willEndGesture: { position in
                                        self.willEndPosition = position
                        },
                                       endGestureHandler: { handler in
                                        self.draggableCoverEndGestureHandler(handler: handler)
                        })
                    } else {
                        DiscoverCoverImage(imageLoader: ImageLoader(path: self.store.state.moviesState.movies[id]!.poster_path,
                                                                    size: .medium))
                            .scaleEffect(1.0 - CGFloat(self.movies.reversed().firstIndex(of: id)!) * 0.03 + CGFloat(self.scaleResistance()))
                            .padding(.bottom, CGFloat(self.movies.reversed().firstIndex(of: id)! * 16) - self.dragResistance())
                            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
                    }
                }
            }
            GeometryReader { reader in
                self.actionsButtons
                    .position(x: reader.frame(in: .local).midX,
                              y: reader.frame(in: .local).maxY - reader.safeAreaInsets.bottom - self.bottomSafeInsetFix)
            }
        }
            .sheet(isPresented: $isFilterFormPresented,
                   onDismiss: { self.isFilterFormPresented = false},
                   content: { DiscoverFilterForm(ondismiss: {
                    self.isFilterFormPresented = false
                   }).environmentObject(self.store) })
            .onAppear {
                self.hapticFeedback.prepare()
                self.fetchRandomMovies(force: false, filter: self.filter)
        }
    }
}

#if DEBUG
struct DiscoverView_Previews : PreviewProvider {
    static var previews: some View {
        DiscoverView().environmentObject(store)
    }
}
#endif
