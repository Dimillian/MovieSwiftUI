//
//  RoundedBadge.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct RoundedBadge : View {
    let text: String
    var body: some View {
        HStack {
            Text(text.capitalized)
                .font(.footnote)
                .fontWeight(.bold)
                .color(.white)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 5)
                .padding(.bottom, 5)
            
            }
            .background(
                Rectangle()
                    .foregroundColor(.gray)
                    .cornerRadius(12)
        )
    }
}

#if DEBUG
struct RoundedBadge_Previews : PreviewProvider {
    static var previews: some View {
        RoundedBadge(text: "Test")
    }
}
#endif
