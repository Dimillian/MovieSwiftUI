//
//  MovieRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

struct MovieRow : View {
    // MARK: - Store
    @EnvironmentObject var store: Store<AppState>
    
    // MARK: - Init
    let movieId: Int
    var displayListImage = true
    var isSelected = false
    
    // MARK: - Private state
    @State private var isPressing = false
    @State private var addSheetShown = false
    
    // MARK: - Private computed vars
    private var movie: Movie! {
        store.state.moviesState.movies[movieId]
    }
    
    private var listImage: String? {
        if isSelected {
            return "checkmark.circle.fill"
        }
        guard displayListImage else {
            return nil
        }
        if store.state.moviesState.wishlist.contains(movieId) {
            return "heart.fill"
        } else if   store.state.moviesState.seenlist.contains(movieId) {
            return "eye.fill"
        } else if store.state.moviesState.customLists.contains(where: { (_, value) -> Bool in
            value.movies.contains(self.movieId)
        }) {
            return "pin.fill"
        }
        return nil
    }
    
    var addActionSheet: ActionSheet {
        get {
            var buttons: [Alert.Button] = []
            let wishlistButton = ActionSheet.wishlistButton(store: store, movie: movieId) {
                self.addSheetShown = false
            }
            let seenButton = ActionSheet.seenListButton(store: store, movie: movieId) {
                self.addSheetShown = false
            }
            let customListButtons = ActionSheet.customListsButttons(store: store, movie: movieId) {
                self.addSheetShown = false
            }
            let cancelButton = Alert.Button.cancel {
                self.addSheetShown = false
            }
            
            buttons.append(wishlistButton)
            buttons.append(seenButton)
            buttons.append(contentsOf: customListButtons)
            buttons.append(cancelButton)
            let sheet = ActionSheet(title: Text("Add or remove \(movie.userTitle) from your lists"),
                                    message: nil,
                                    buttons: buttons)
            return sheet
        }
    }
    
    // MARK: - Body
    var body: some View {
        HStack {
            ZStack(alignment: .topLeading) {
                MoviePosterImage(imageLoader: ImageLoader(path: movie.poster_path,
                                                          size: .small),
                                 posterSize: .medium)
                    .overlay(isSelected ? Color.blue.opacity(0.5) : nil)
                if listImage != nil {
                    Image(systemName: listImage!)
                        .imageScale(.small)
                        .foregroundColor(.white)
                        .position(x: 13, y: 15)
                        .transition(AnyTransition.scale()
                            .combined(with: .opacity))
                        .animation(.spring())
                    
                }
            }
            .scaleEffect(isPressing ? 1.05 : 1.0)
                .animation(isPressing ?.spring() : nil)
                .longPressAction(minimumDuration: 0.5, {
                    self.addSheetShown = true
                }) { ended in
                    self.isPressing = ended
            }
            .fixedSize()
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.userTitle)
                    .font(.FjallaOne(size: 20))
                    .color(.steam_gold)
                    .lineLimit(2)
                HStack {
                    PopularityBadge(score: Int(movie.vote_average * 10))
                    Text(formatter.string(from: movie.releaseDate ?? Date()))
                        .font(.subheadline)
                        .color(.primary)
                        .lineLimit(1)
                }
                Text(movie.overview)
                    .color(.secondary)
                    .lineLimit(3)
                    .truncationMode(.tail)
            }.padding(.leading, 8)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
        .presentation($addSheetShown) { addActionSheet }
    }
}

#if DEBUG
struct MovieRow_Previews : PreviewProvider {
    static var previews: some View {
        List {
            MovieRow(movieId: sampleMovie.id).environmentObject(sampleStore)
        }
    }
}
#endif
