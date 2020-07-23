//
//  PeopleDetail.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import UI

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
    @State var isFanScoreUpdated = false
    
    //MARK: - Views
    private func toggleScoreUpdate() {
        withAnimation {
            self.isFanScoreUpdated = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isFanScoreUpdated = false
                }
            }
        }
    }
    
    private func moviesSection(props: Props, year: String) -> some View {
        Section(header: Text(year)) {
            ForEach(props.movieByYears[year]!) { meta in
                NavigationLink(destination: MovieDetail(movieId: meta.id)) {
                    PeopleDetailMovieRow(movieId: meta.id, role: meta.role, onMovieContextMenu: {
                        if props.isInFanClub.wrappedValue {
                            self.toggleScoreUpdate()
                        }
                    })
                }
            }
        }
    }
    
    private func barbuttons(props: Props) -> some View {
        Button(action: {
            props.isInFanClub.wrappedValue.toggle()
        }, label: {
            Image(systemName: props.isInFanClub.wrappedValue ? "star.circle.fill" : "star.circle")
                .resizable()
                .foregroundColor(props.isInFanClub.wrappedValue ? .steam_gold : .primary)
                .scaleEffect(props.isInFanClub.wrappedValue ? 1.2 : 1.0)
                .frame(width: 25, height: 25)
                .animation(.spring())
        })
    }
    
    private func scoreUpdateView(props: Props) -> some View {
        Group {
            if isFanScoreUpdated {
                VStack(spacing: 30) {
                    Text("Fan level updated!")
                        .font(.FjallaOne(size: 30))
                        .foregroundColor(.steam_gold)
                    PopularityBadge(score: props.movieScore ?? 0)
                        .scaleEffect(2.0)
                }
                .transition(.scale)
                .animation(Animation
                    .interpolatingSpring(stiffness: 70, damping: 7)
                .delay(0.3))
                .onTapGesture {
                    self.isFanScoreUpdated = false
                }
            }
        }
    }
    
    private func imagesCarouselView(props: Props) -> some View {
        ImagesCarouselView(posters: props.people.images ?? [],
                           selectedPoster: $selectedPoster)
            .scaleEffect(selectedPoster != nil ? 1.0 : 1.2)
            .blur(radius: selectedPoster != nil ? 0 : 10)
            .opacity(selectedPoster != nil ? 1 : 0)
            .animation(.spring())
    }
    
    func body(props: Props) -> some View {
        ZStack(alignment: .center) {
            List {
                Section {
                    PeopleDetailHeaderRow(peopleId: peopleId)
                    if props.people.birthDay != nil ||
                        props.people.birthDay != nil ||
                        props.people.place_of_birth != nil ||
                        props.people.deathDay != nil {
                        PeopleDetailBiographyRow(biography: props.people.biography,
                                                 birthDate: props.people.birthDay,
                                                 deathDate: props.people.deathDay,
                                                 placeOfBirth: props.people.place_of_birth)
                    }
                    if props.isInFanClub.wrappedValue {
                        VStack {
                            Text("Fan level")
                                .titleStyle()
                            PopularityBadge(score: props.movieScore ?? 0)
                        }
                    }
                    if props.people.images != nil {
                        PeopleDetailImagesRow(images: props.people.images!, selectedPoster: $selectedPoster)
                    }
                }
                ForEach(sortedYears(props: props), id: \.self, content: { year in
                    self.moviesSection(props: props, year: year)
                })
            }
            .animation(nil)
            .blur(radius: selectedPoster != nil || isFanScoreUpdated ? 30 : 0)
            .scaleEffect(selectedPoster != nil ? 0.8 : 1)
            .animation(.interactiveSpring())
            imagesCarouselView(props: props)
            scoreUpdateView(props: props)
        }
        .animation(.spring())
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
            get: { state.peoplesState.fanClub.contains(self.peopleId) },
            set: {
                if !$0 {
                    dispatch(PeopleActions.RemoveFromFanClub(people: self.peopleId))
                } else {
                    dispatch(PeopleActions.AddToFanClub(people: self.peopleId))
                }
        }
        )
        
        var movieScore: Int = 0
        if isInFanClub.wrappedValue {
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
