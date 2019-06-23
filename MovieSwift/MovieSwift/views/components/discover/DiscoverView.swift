//
//  DiscoverView.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct DiscoverView : View {
    
    // MARk: - State vars
    
    @EnvironmentObject var store: AppStore
    @State var draggedViewState = DraggableCover.DragState.inactive
    @State var previousMovie: Int? = nil
    @State var filterFormPresented = false
    @State var movieDetailPresented = false
    
    // MARK: - Computed properties
    
    var movies: [Int] {
        store.state.moviesState.discover
    }
    
    var filter: DiscoverFilter? {
        store.state.moviesState.discoverFilter
    }
    
    var currentMovie: Movie {
        return store.state.moviesState.movies[store.state.moviesState.discover.reversed()[0].id]!
    }
    
    func dragResistance() -> CGFloat {
        abs(draggedViewState.translation.width) / 5
    }
    
    func opacityResistance() -> Double {
        Double(abs(draggedViewState.translation.width) / 800)
    }
    
    func leftZoneResistance() -> CGFloat {
        -draggedViewState.translation.width / 1000
    }
    
    func rightZoneResistance() -> CGFloat {
        draggedViewState.translation.width / 1000
    }
    
    func doneGesture(handler: DraggableCover.EndState) {
        if handler == .left || handler == .right {
            previousMovie = currentMovie.id
            if handler == .left {
                store.dispatch(action: MoviesActions.addToWishlist(movie: currentMovie.id))
            } else if handler == .right {
                store.dispatch(action: MoviesActions.addToSeenlist(movie: currentMovie.id))
            }
            store.dispatch(action: MoviesActions.PopRandromDiscover())
            fetchRandomMovies()
        }
    }
    
    func fetchRandomMovies() {
        if movies.count < 10 {
            store.dispatch(action: MoviesActions.FetchRandomDiscover(filter: filter))
        }
    }
    
    // MARK: - Modals
    
    var filterFormModal: Modal {
        Modal(DiscoverFilterForm(isPresented: $filterFormPresented).environmentObject(store),
              onDismiss: {
            self.filterFormPresented = false
        })
    }
    
    var movieDetailModal: Modal {
        Modal(NavigationView{ MovieDetail(movieId: currentMovie.id).environmentObject(store) }) {
            self.movieDetailPresented = false
        }
    }
    
    var currentModal: Modal? {
        if filterFormPresented {
            return filterFormModal
        } else if movieDetailPresented {
            return movieDetailModal
        }
        return nil
    }
    
    // MARK: Body views
    var filterView: some View {
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
    
    var zonesButtons: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if !self.movies.isEmpty {
                    Text(self.currentMovie.original_title)
                        .color(.primary)
                        .multilineTextAlignment(.center)
                        .font(.FHACondFrenchNC(size: 18))
                        .lineLimit(2)
                        .opacity(self.draggedViewState.isDragging ? 0.0 : 1.0)
                        .position(x: geometry.frame(in: .global).midX,
                                  y: geometry.frame(in: .global).midY + 170)
                        .animation(.basic())
                        .tapAction {
                            self.movieDetailPresented = true
                    }
                    
                    
                    Circle()
                        .strokeBorder(Color.pink, lineWidth: 1)
                        .background(Image(systemName: "heart.fill").foregroundColor(.pink))
                        .frame(width: 50, height: 50)
                        .position(x: geometry.frame(in: .global).midX - 50, y: geometry.frame(in: .global).midY + 200)
                        .opacity(self.draggedViewState.isDragging ? 0.3 + Double(self.leftZoneResistance()) : 0)
                        .animation(.fluidSpring())
                    
                    Circle()
                        .strokeBorder(Color.green, lineWidth: 1)
                        .background(Image(systemName: "eye.fill").foregroundColor(.green))
                        .frame(width: 50, height: 50)
                        .position(x: geometry.frame(in: .global).midX + 50, y: geometry.frame(in: .global).midY + 200)
                        .opacity(self.draggedViewState.isDragging ? 0.3 + Double(self.rightZoneResistance()) : 0)
                        .animation(.fluidSpring())
                    
                    
                    Circle()
                        .strokeBorder(Color.red, lineWidth: 1)
                        .background(Image(systemName: "xmark").foregroundColor(.red))
                        .frame(width: 50, height: 50)
                        .position(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY + 230)
                        .opacity(self.draggedViewState.isDragging ? 0.0 : 1)
                        .animation(.fluidSpring())
                        .tapAction {
                            self.previousMovie = self.currentMovie.id
                            self.store.dispatch(action: MoviesActions.PopRandromDiscover())
                            self.fetchRandomMovies()
                    }
                    
                    Button(action: {
                        self.store.dispatch(action: MoviesActions.PushRandomDiscover(movie: self.previousMovie!))
                        self.previousMovie = nil
                    }, label: {
                        Image(systemName: "gobackward").foregroundColor(.steam_blue)
                    }) .frame(width: 50, height: 50)
                        .position(x: geometry.frame(in: .global).midX - 60,
                                  y: geometry.frame(in: .global).midY + 230)
                        .opacity(self.previousMovie != nil && !self.draggedViewState.isActive ? 1 : 0)
                        .animation(.fluidSpring())
                    
                    Button(action: {
                        self.store.dispatch(action: MoviesActions.ResetRandomDiscover())
                        self.fetchRandomMovies()
                    }, label: {
                        Image(systemName: "arrow.swap")
                            .foregroundColor(.steam_blue)
                    })
                        .frame(width: 50, height: 50)
                        .position(x: geometry.frame(in: .global).midX + 60,
                                  y: geometry.frame(in: .global).midY + 230)
                        .opacity(self.draggedViewState.isDragging ? 0.0 : 1.0)
                        .animation(.fluidSpring())
                }
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { reader in
                self.filterView.position(x: reader.frame(in: .global).midX,
                                    y: 30)
            }
            zonesButtons
            ForEach(movies) {id in
                if self.movies.reversed().firstIndex(of: id) == 0 {
                    DraggableCover(movieId: id,
                                   gestureViewState: self.$draggedViewState,
                                   endGestureHandler: { handler in
                                    self.doneGesture(handler: handler)
                    })
                } else {
                    DiscoverCoverImage(imageLoader: ImageLoader(poster: self.store.state.moviesState.movies[id]!.poster_path,
                                                                size: .small))
                        .padding(.bottom, Length(self.movies.reversed().firstIndex(of: id)! * 8) - self.dragResistance())
                        .opacity(Double(self.movies.firstIndex(of: id)!) * 0.05 + self.opacityResistance())
                        .animation(.spring())
                }
            }
            }
            .presentation(currentModal)
            .onAppear {
                self.fetchRandomMovies()
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
