//
//  PeopleDetailBiography.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIFlux

struct PeopleDetailBiographyRow : View {
    let biography: String?
    let birthDate: String?
    let deathDate: String?
    let placeOfBirth: String?
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if biography != nil {
                Text("Biography")
                    .titleStyle()
                    .lineLimit(1)
                Text(biography!)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .lineLimit(isExpanded ? 1000 : 4)
            }
            Button(action: {
                self.isExpanded.toggle()
            }) {
                Text(isExpanded ? "Less": "Read more").foregroundColor(.steam_blue)
            }
            if birthDate != nil {
                Text("Birthday")
                    .titleStyle()
                    .lineLimit(1)
                Text(birthDate!)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .lineLimit(1)
            }
            if placeOfBirth != nil {
                Text("Place of birth")
                    .titleStyle()
                    .lineLimit(1)
                Text(placeOfBirth!)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .lineLimit(1)
            }
            if deathDate != nil {
                Text("Day of deah")
                    .titleStyle()
                    .lineLimit(1)
                Text(deathDate!)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .lineLimit(1)
            }
        }
    }
}

#if DEBUG
struct PeopleDetailBiography_Previews : PreviewProvider {
    static var previews: some View {
        PeopleDetailBiographyRow(biography: "Super bio",
                                 birthDate: "1985-02-03",
                                 deathDate: "2005-02-05",
                                 placeOfBirth: "USA")
    }
}
#endif
