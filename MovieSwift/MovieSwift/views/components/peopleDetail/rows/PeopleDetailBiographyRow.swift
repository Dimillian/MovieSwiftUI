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
                Text("Biography:")
                    .font(.FjallaOne(size: 16))
                    .fontWeight(.bold)
                Text(biography!)
                    .foregroundColor(.secondary)
                    .font(.body)
                    .lineLimit(isExpanded ? nil : 4)
            }
            Button(action: {
                self.isExpanded.toggle()
            }) {
                Text(isExpanded ? "Less": "Read more").foregroundColor(.steam_blue)
            }
            if birthDate != nil {
                Text("Birthday:")
                    .font(.FjallaOne(size: 16))
                    .fontWeight(.bold)
                Text(birthDate!)
                    .foregroundColor(.secondary)
                    .font(.body)
            }
            if placeOfBirth != nil {
                Text("Place of birth:")
                    .font(.FjallaOne(size: 16))
                    .fontWeight(.bold)
                Text(placeOfBirth!)
                    .foregroundColor(.secondary)
                    .font(.body)
            }
            if deathDate != nil {
                Text("Day of deah:")
                    .font(.FjallaOne(size: 16))
                    .fontWeight(.bold)
                Text(deathDate!)
                    .foregroundColor(.secondary)
                    .font(.body)
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
