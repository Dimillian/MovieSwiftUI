//
//  PeopleDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PeopleDetail : View {
    @EnvironmentObject private var store: Store<AppState>
    let peopleId: Int
    @State var selectedPoster: ImageData?
    
    private var people: People {
        store.state.peoplesState.peoples[peopleId]!
    }
    
    private struct MovieRole: Identifiable {
        let id: Int
        let role: String
    }
    
    private var moviesByYears: [String: [MovieRole]] {
        get {
            var years: [String: [MovieRole]] = [:]
            computeYears(roles: store.state.peoplesState.crews[peopleId] ?? [:], years: &years)
            computeYears(roles: store.state.peoplesState.casts[peopleId] ?? [:], years: &years)
            return years
        }
    }
    
    private var sortedYears: [String] {
        moviesByYears.compactMap{ $0.key }.sorted(by: { $0 > $1 })
    }
    
    private func computeYears(roles: [Int: String], years: inout [String: [MovieRole]]) {
        for (_, value) in roles.enumerated() {
            if let movie = store.state.moviesState.movies[value.key] {
                if movie.release_date != nil && movie.release_date?.isEmpty == false {
                    let year = String(movie.release_date!.prefix(4))
                    if years[year] == nil {
                        years[year] = []
                    }
                    years[year]?.append(MovieRole(id: value.key, role: value.value))
                } else {
                    if years["Upcoming"] == nil {
                        years["Upcoming"] = []
                    }
                    years["Upcoming"]?.append(MovieRole(id: value.key, role: value.value))
                }
            }
        }
    }
    
    func moviesSection(year: String) -> some View {
        Section(header: Text(year)) {
            ForEach(self.moviesByYears[year]!) { meta in
                NavigationLink(destination: MovieDetail(movieId: meta.id).environmentObject(self.store)) {
                    PeopleDetailMovieRow(movieId: meta.id, role: meta.role)
                }
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                PeopleDetailHeaderRow(peopleId: peopleId)
                PeopleDetailBiographyRow(biography: people.biography,
                                         birthDate: people.birthDay,
                                         deathDate: people.deathDay,
                                         placeOfBirth: people.place_of_birth)
                if people.images != nil {
                    PeopleDetailImagesRow(images: people.images!, selectedPoster: $selectedPoster)
                }
                ForEach(sortedYears, id: \.self, content: { year in
                    self.moviesSection(year: year)
                })
            }
            .blur(radius: selectedPoster != nil ? 30 : 0)
            if selectedPoster != nil && people.images != nil {
                ImagesCarouselView(posters: people.images!,
                                   selectedPoster: $selectedPoster)
            }
        }
        .navigationBarTitle(people.name)
        .onAppear {
            self.store.dispatch(action: PeopleActions.FetchDetail(people: self.peopleId))
            self.store.dispatch(action: PeopleActions.FetchImages(people: self.peopleId))
            self.store.dispatch(action: PeopleActions.FetchPeopleCredits(people: self.peopleId))
        }
    }
}

#if DEBUG
struct PeopleDetail_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            PeopleDetail(peopleId: sampleCasts.first!.id).environmentObject(sampleStore)
        }
    }
}
#endif
