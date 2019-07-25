//
//  PeopleDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PeopleDetail: ConnectedView {
    // MARK: - Props
    struct Props {
        let dispatch: DispatchFunction
        let people: People
        let movieByYears: [String: [MovieRole]]
        let isInFanClub: Binding<Bool>
        let movieScore: Int?
    }
    
    struct MovieRole: Identifiable {
        let id: Int
        let role: String
    }
    
    let peopleId: Int
    
    @State var selectedPoster: ImageData?
    
    //MARK: - Views
    private func moviesSection(props: Props, year: String) -> some View {
        Section(header: Text(year)) {
            ForEach(props.movieByYears[year]!) { meta in
                NavigationLink(destination: MovieDetail(movieId: meta.id)) {
                    PeopleDetailMovieRow(movieId: meta.id, role: meta.role)
                }
            }
        }
    }
    
    private func barbuttons(props: Props) -> some View {
        HStack {
            if props.isInFanClub.value {
                PopularityBadge(score: props.movieScore ?? 0)
            }
            Button(action: {
                props.isInFanClub.value.toggle()
            }, label: {
                Image(systemName: props.isInFanClub.value ? "star.circle.fill" : "star.circle")
                    .resizable()
                    .foregroundColor(props.isInFanClub.value ? .steam_gold : .primary)
                    .scaleEffect(props.isInFanClub.value ? 1.2 : 1.0)
                    .frame(width: 25, height: 25)
                    .animation(.spring())
            })
        }
    }
    
    func body(props: Props) -> some View {
        ZStack(alignment: .bottom) {
            List {
                Section {
                    PeopleDetailHeaderRow(peopleId: peopleId)
                    PeopleDetailBiographyRow(biography: props.people.biography,
                                             birthDate: props.people.birthDay,
                                             deathDate: props.people.deathDay,
                                             placeOfBirth: props.people.place_of_birth)
                    if props.people.images != nil {
                        PeopleDetailImagesRow(images: props.people.images!, selectedPoster: $selectedPoster)
                    }
                }
                ForEach(sortedYears(props: props), id: \.self, content: { year in
                    self.moviesSection(props: props, year: year)
                })
            }
            .blur(radius: selectedPoster != nil ? 30 : 0)
            if selectedPoster != nil && props.people.images != nil {
                ImagesCarouselView(posters: props.people.images!,
                                   selectedPoster: $selectedPoster)
            }
        }
        .navigationBarItems(trailing: barbuttons(props: props))
           .navigationBarTitle(props.people.name)
            .onAppear {
                props.dispatch(PeopleActions.FetchDetail(people: self.peopleId))
                props.dispatch(PeopleActions.FetchImages(people: self.peopleId))
                props.dispatch(PeopleActions.FetchPeopleCredits(people: self.peopleId))
        }
    }
}

// MARK: - Map state to props
extension PeopleDetail {
    private func sortedYears(props: Props) -> [String] {
        props.movieByYears.compactMap{ $0.key }.sorted(by: { $0 > $1 })
    }
    
    func map(state: AppState, dispatch: @escaping DispatchFunction) -> Props {
        var years: [String: [MovieRole]] = [:]
        var credits: [Int: String] = state.peoplesState.crews[peopleId] ?? [:]
        credits.merge(state.peoplesState.casts[peopleId] ?? [:]) { (current, _) in current }
        for (_, value) in credits.enumerated() {
            if let movie = state.moviesState.movies[value.key] {
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
        for value in years {
            years[value.key] = value.value.sorted(by: { $0.id > $1.id })
        }
        
        let isInFanClub = Binding<Bool>(
            getValue: { state.peoplesState.fanClub.contains(self.peopleId) },
            setValue: { newValue in
                if !newValue {
                    dispatch(PeopleActions.RemoveFromFanClub(people: self.peopleId))
                } else {
                    dispatch(PeopleActions.AddToFanClub(people: self.peopleId))
                }
        }
        )
        
        var movieScore: Int = 0
        if isInFanClub.value {
            let roles = years.map{ $0.value }.flatMap{ $0 }.map{ $0.id }
            let rolesCount = roles.count
            let userMovies = roles.filter { movie -> Bool in
                            state.moviesState.seenlist.contains(movie) ||
                            state.moviesState.wishlist.contains(movie) ||
                                state.moviesState.customLists.contains{ $1.movies.contains(movie) }
                        }
            movieScore = userMovies.count > 0 ? Int((Float(userMovies.count) / Float(rolesCount)) * 100) : 0
        }
        
        return Props(dispatch: dispatch,
                     people: state.peoplesState.peoples[peopleId]!,
                     movieByYears: years,
                     isInFanClub: isInFanClub,
                     movieScore: movieScore)
        
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
