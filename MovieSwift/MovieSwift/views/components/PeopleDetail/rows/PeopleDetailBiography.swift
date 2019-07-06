//
//  PeopleDetailBiography.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PeopleDetailBiography : View {
    let biography: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Biography:")
                .font(.FjallaOne(size: 16))
                .fontWeight(.bold)
            Text(biography)
                .color(.secondary)
                .font(.body)
                .lineLimit(isExpanded ? nil : 4)
            Button(action: {
                self.isExpanded.toggle()
            }) {
                Text(isExpanded ? "Less": "Read more").color(.steam_blue)
            }
        }
    }
}

#if DEBUG
struct PeopleDetailBiography_Previews : PreviewProvider {
    static var previews: some View {
        PeopleDetailBiography(biography: "Super bio")
    }
}
#endif
