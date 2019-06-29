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
    @State private var filterFormPresented = false
    @State private var movieDetailPresented = false
    @State private var willEndPosition: CGSize? = nil
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .soft)
    
    #if targetEnvironment(UIKitForMac)
    private let bottomSafeInsetFix: Length = 50
    #else
    private let bottomSafeInsetFix: Length = 20
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
        return store.state.moviesState.movies[movies.reversed()[0].id]
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
                hapticFeedback.impactOccurred(withIntensity: 0.8)
                store.dispatch(action: MoviesActions.AddToWishlist(movie: currentMovie.id))
            } else if handler == .right {
                hapticFeedback.impactOccurred(withIntensity: 0.8)
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
    
    // MARK: - Modals
    
    private var filterFormModal: Modal {
        Modal(DiscoverFilterForm(isPresented: $filterFormPresented).environmentObject(store),
              onDismiss: {
            self.filterFormPresented = false
        })
    }
    
    private var movieDetailModal: Modal {
        let content = NavigationView{ MovieDetail(movieId: currentMovie!.id).environmentObject(store) }
        return Modal(content) {
            self.movieDetailPresented = false
        }
    }
    
    private var currentModal: Modal? {
        if filterFormPresented {
            return filterFormModal
        } else if movieDetailPresented {
            return movieDetailModal
        }
        return nil
    }
    
    // MARK: Body views
    private var filterView: some View {
        var text = String("")
        if let startYear = filter?.startYear, let endYear = filter?.endYear {
            text = text + "\(startYear)-\(endYear)"
        } else {
            text = text + "\(filter?.year != nil ? String(filter!.year) : "Loading") · Random"
        }
        if let genre = filter?.genre,
            let stateGenre = store.state.moviesState.genres.first(where: { (realGenre) -> Bool in
            realGenre.id == genre
        }) {
            text = text + " · \(stateGenre.name)"
        }
        if let region = filter?.region {
            text = text + " · \(region)"
        }
        return BorderedButton(text: text,
                              systemImageName: "line.horizontal.3.decrease",
                              color: .steam_blue,
                              isOn: false) {
                                self.filterFormPresented = true
        }
    }
    
    private var actionsButtons: some View {
        ZStack(alignment: .center) {
            if self.currentMovie != nil {
                Text(self.currentMovie!.userTitle)
                    .color(.primary)
                    .multilineTextAlignment(.center)
                    .font(.FjallaOne(size: 18))
                    .lineLimit(2)
                    .opacity(self.draggedViewState.isDragging ? 0.0 : 1.0)
                    .offset(x: 0, y: -15)
                    .animation(.basic())
                
                Circle()
                    .strokeBorder(Color.pink, lineWidth: 1)
                    .background(Image(systemName: "heart.fill").foregroundColor(.pink))
                    .frame(width: 50, height: 50)
                    .offset(x: -70, y: 0)
                    .opacity(self.draggedViewState.isDragging ? 0.3 + Double(self.leftZoneResistance()) : 0)
                    .animation(.fluidSpring())
                
                Circle()
                    .strokeBorder(Color.green, lineWidth: 1)
                    .background(Image(systemName: "eye.fill").foregroundColor(.green))
                    .frame(width: 50, height: 50)
                    .offset(x: 70, y: 0)
                    .opacity(self.draggedViewState.isDragging ? 0.3 + Double(self.rightZoneResistance()) : 0)
                    .animation(.fluidSpring())
                
                
                Circle()
                    .strokeBorder(Color.red, lineWidth: 1)
                    .background(Image(systemName: "xmark").foregroundColor(.red))
                    .frame(width: 50, height: 50)
                    .offset(x: 0, y: 30)
                    .opacity(self.draggedViewState.isDragging ? 0.0 : 1)
                    .animation(.fluidSpring())
                    .tapAction {
                        self.hapticFeedback.impactOccurred(withIntensity: 0.5)
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
                    .animation(.fluidSpring())
                
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
                    .animation(.fluidSpring())
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
            ForEach(movies) {id in
                if self.movies.reversed().firstIndex(of: id) == 0 {
                    DraggableCover(movieId: id,
                                   gestureViewState: self.$draggedViewState,
                                   onTapGesture: {
                                    self.movieDetailPresented = true
                    },
                                   willEndGesture: { position in
                                    self.willEndPosition = position
                    },
                                   endGestureHandler: { handler in
                                    self.draggableCoverEndGestureHandler(handler: handler)
                    })
                } else {
                    DiscoverCoverImage(imageLoader: ImageLoader(poster: self.store.state.moviesState.movies[id]!.poster_path,
                                                                size: .small))
                        .scaleEffect(1.0 - Length(self.movies.reversed().firstIndex(of: id)!) * 0.03 + Length(self.scaleResistance()))
                        .padding(.bottom, Length(self.movies.reversed().firstIndex(of: id)! * 16) - self.dragResistance())
                        .animation(.spring())
                }
            }
            GeometryReader { reader in
                self.actionsButtons
                    .position(x: reader.frame(in: .local).midX,
                              y: reader.frame(in: .local).maxY - reader.safeAreaInsets.bottom - self.bottomSafeInsetFix)
            }
            }
            .presentation(currentModal)
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
