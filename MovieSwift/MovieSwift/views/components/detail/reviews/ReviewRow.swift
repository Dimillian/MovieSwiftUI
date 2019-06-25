
//
//  ReviewRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ReviewRow : View {
    let review: Review
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Review writtent by \(review.author)").font(.subheadline).fontWeight(.bold)
            Text(review.content).font(.body).lineLimit(0)
        }
            .padding(.top)
            .padding(.bottom)
    }
}

#if DEBUG
struct ReviewRow_Previews : PreviewProvider {
    static var previews: some View {
        ReviewRow(review: Review(id: "0", author: "Test", content: "Test body"))
    }
}
#endif
