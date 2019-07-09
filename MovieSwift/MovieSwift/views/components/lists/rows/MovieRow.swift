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
    @EnvironmentObject var store: Store<AppState>
    
    let movieId: Int
    
    private var movie: Movie! {
        return store.state.moviesState.movies[movieId]
    }
    @State private var isPressing = false
    @State private var addSheetShown = false
    
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
            let sheet = ActionSheet(title: Text("Add to"),
                                    message: Text("Add this movie to your list"),
                                    buttons: buttons)
            return sheet
        }
    }
        
    var body: some View {
        HStack {
            MoviePosterImage(imageLoader: ImageLoader(path: movie.poster_path,
                                                      size: .small),
                             posterSize: .medium)
                .scaleEffect(isPressing ? 1.05 : 1.0)
                .animation(isPressing ?.spring() : nil)
                .longPressAction(minimumDuration: 0.5, maximumDistance: 1, {
                    self.addSheetShown = true
                }) { ended in
                    self.isPressing = ended
                }
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.userTitle)
                    .font(.FjallaOne(size: 20))
                    .color(.steam_gold)
                    .lineLimit(2)
                HStack {
                    PopularityBadge(score: Int(movie.vote_average * 10))
                    Text(formatter.string(from: movie.releaseDate ?? Date()))
                        .font(.subheadline)
                        .color(.secondary)
                        .lineLimit(1)
                }
                Text(movie.overview)
                    .color(.secondary)
                    .lineLimit(3)
                    .truncationMode(.tail)
            }.padding(.leading, 8)
        }
        .padding(8)
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
