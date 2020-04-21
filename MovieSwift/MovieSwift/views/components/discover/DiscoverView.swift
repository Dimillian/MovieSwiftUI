//
//  DiscoverView.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Backend
import UI

struct DiscoverView: ConnectedView {
    
    // MARK: - Props
    struct Props {
        let movies: [Int]
        let posters: [Int: String]
        let currentMovie: Movie?
        let filter: DiscoverFilter?
        let genres: [Genre]
        let dispatch: DispatchFunction
    }
    
    // MARK: - State vars
    @State private var draggedViewState = DraggableCover.DragState.inactive
    @State private var previousMovie: Int? = nil
    @State private var presentedMovie: Movie? = nil
    @State private var isFilterFormPresented = false
    @State private var willEndPosition: CGSize? = nil
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .soft)
    
    #if targetEnvironment(macCatalyst)
    private let bottomSafeInsetFix: CGFloat = 100
    #else
    private let bottomSafeInsetFix: CGFloat = 20
    #endif
    
    // MARK: - Map State to Props
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        var posters: [Int: String] = [:]
        let movies = state.moviesState.discover
        for movie in movies {
            posters[movie] = state.moviesState.movies[movie]!.poster_path
        }
        return Props(movies: movies,
                     posters: posters,
                     currentMovie: movies.isEmpty ? nil : state.moviesState.movies[movies.reversed()[0]],
                     filter: state.moviesState.discoverFilter,
                     genres: state.moviesState.genres,
                     dispatch: dispatch)
    }
    
    // MARK: - Functions
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
    
    private func draggableCoverEndGestureHandler(props: Props, handler: DraggableCover.EndState) {
        guard let currentMovie = props.currentMovie else {
            return
        }
        if handler == .left || handler == .right {
            previousMovie = currentMovie.id
            if handler == .left {
                hapticFeedback.impactOccurred(intensity: 0.8)
                props.dispatch(MoviesActions.AddToWishlist(movie: currentMovie.id))
            } else if handler == .right {
                hapticFeedback.impactOccurred(intensity: 0.8)
                props.dispatch(MoviesActions.AddToSeenList(movie: currentMovie.id))
            }
            store.dispatch(action: MoviesActions.PopRandromDiscover())
            willEndPosition = nil
            fetchRandomMovies(props: props, force: false, filter: props.filter)
        }
    }
    
    private func fetchRandomMovies(props: Props, force: Bool, filter: DiscoverFilter?) {
        if props.movies.count < 10 || force {
            props.dispatch(MoviesActions.FetchRandomDiscover(filter: filter))
        }
    }
    
    // MARK: Body views
    private func filterView(props: Props) -> some View {
        return BorderedButton(text: props.filter?.toText(genres: props.genres) ?? "Loading...",
                              systemImageName: "line.horizontal.3.decrease",
                              color: .steam_blue,
                              isOn: false) {
                                self.isFilterFormPresented = true
        }
    }
    
    private func actionsButtons(props: Props) -> some View {
        ZStack(alignment: .center) {
            if props.currentMovie != nil {
                Text(props.currentMovie!.userTitle)
                    .foregroundColor(.white)
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
                        self.previousMovie = props.currentMovie!.id
                        props.dispatch(MoviesActions.PopRandromDiscover())
                        self.fetchRandomMovies(props: props, force: false, filter: props.filter)
                }
                
                Button(action: {
                    props.dispatch(MoviesActions.PushRandomDiscover(movie: self.previousMovie!))
                    self.previousMovie = nil
                }, label: {
                    Image(systemName: "gobackward").foregroundColor(.steam_blue)
                }) .frame(width: 50, height: 50)
                    .offset(x: -60, y: 30)
                    .opacity(self.previousMovie != nil && !self.draggedViewState.isActive ? 1 : 0)
                    .animation(.spring())
                
                Button(action: {
                    props.dispatch(MoviesActions.ResetRandomDiscover())
                    self.fetchRandomMovies(props: props, force: true, filter: nil)
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
    
    private func draggableMovies(props: Props) -> some View {
        ForEach(props.movies, id: \.self) { id in
            Group {
                if props.movies.reversed().firstIndex(of: id) == 0 {
                    DraggableCover(movieId: id,
                                   gestureViewState: self.$draggedViewState,
                                   onTapGesture: {
                                    self.presentedMovie = props.currentMovie
                    },
                                   willEndGesture: { position in
                                    self.willEndPosition = position
                    },
                                   endGestureHandler: { handler in
                                    self.draggableCoverEndGestureHandler(props: props, handler: handler)
                    })
                        .sheet(item: self.$presentedMovie, onDismiss: {
                            self.presentedMovie = nil
                        }, content: { movie in
                            NavigationView {
                                MovieDetail(movieId: movie.id)
                            }.navigationViewStyle(StackNavigationViewStyle())
                                .environmentObject(store)
                        })
                } else {
                    DiscoverCoverImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: props.posters[id],
                                                                                      size: .medium))
                        .scaleEffect(1.0 - CGFloat(props.movies.reversed().firstIndex(of: id)!) * 0.03 + CGFloat(self.scaleResistance()))
                        .padding(.bottom, CGFloat(props.movies.reversed().firstIndex(of: id)! * 16) - self.dragResistance())
                        .animation(self.draggedViewState.isActive ?
                            .easeIn(duration: 0) :
                            .spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
                }
            }
        }
    }
    
    func body(props: Props) -> some View {
        ZStack(alignment: .center) {
            draggableMovies(props: props)
            GeometryReader { reader in
                self.filterView(props: props)
                    .position(x: reader.frame(in: .local).midX,
                              y: reader.frame(in: .local).minY + reader.safeAreaInsets.top + 10)
                    .frame(height: 50)
                    .sheet(isPresented: self.$isFilterFormPresented, content: { DiscoverFilterForm().environmentObject(store) })
                self.actionsButtons(props: props)
                    .position(x: reader.frame(in: .local).midX,
                              y: reader.frame(in: .local).maxY - reader.safeAreaInsets.bottom - self.bottomSafeInsetFix)
            }
        }
        .background(FullscreenMoviePosterImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: props.currentMovie?.poster_path,
                                                                                              size: .original))
            .allowsHitTesting(false)
            .transition(.opacity)
            .animation(.easeInOut))
        .onAppear {
            self.hapticFeedback.prepare()
            self.fetchRandomMovies(props: props, force: false, filter: props.filter)
            props.dispatch(MoviesActions.FetchGenres())
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
