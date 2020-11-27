//
//  CastRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux
import Backend

struct MovieCrosslinePeopleRow : View {
    let title: String
    let peoples: [People]
    
    private var peoplesListView: some View {
        List(peoples) { cast in
            PeopleListItem(people: cast)
        }.navigationBarTitle(title)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .titleStyle()
                    .padding(.leading)
                NavigationLink(destination: peoplesListView,
                               label: {
                    Text("See all").foregroundColor(.steam_blue)
                })
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(peoples) { cast in
                        PeopleRowItem(people: cast)
                    }
                }.padding(.leading)
            }
        }
        .listRowInsets(EdgeInsets())
        .padding(.vertical)
    }
}

struct PeopleListItem: View {
    let people: People
    
    var body: some View {
        NavigationLink(destination: PeopleDetail(peopleId: people.id)) {
            HStack {
                PeopleImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: people.profile_path,
                                                     size: .cast))
                VStack(alignment: .leading, spacing: 8) {
                    Text(people.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Text(people.character ?? people.department ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }.contextMenu{ PeopleContextMenu(people: people.id) }
        }
    }
}

struct PeopleRowItem: View {
    let people: People
    
    var body: some View {
        NavigationLink(destination: PeopleDetail(peopleId: people.id)) {
            VStack(alignment: .center) {
                PeopleImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: people.profile_path,
                                                                           size: .cast))
                Text(people.name)
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(people.character ?? people.department ?? "")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(width: 100)
            .contextMenu{ PeopleContextMenu(people: people.id) }
        }
    }
}

#if DEBUG
struct CastsRow_Previews : PreviewProvider {
    static var previews: some View {
        MovieCrosslinePeopleRow(title: "Sample", peoples: sampleCasts)
    }
}
#endif
