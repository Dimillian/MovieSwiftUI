//
//  RoundedBadge.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 16/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

public struct RoundedBadge : View {
    public let text: String
    public let color: Color
    
    public init(text: String, color: Color) {
        self.text = text
        self.color = color
    }
    
    public var body: some View {
        HStack {
            Text(text.capitalized)
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.leading, 10)
                .padding([.top, .bottom], 5)
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 5, height: 10)
                .foregroundColor(.primary)
                .padding(.trailing, 10)
            
            }
            .background(
                Rectangle()
                    .foregroundColor(color)
                    .cornerRadius(12)
        )
            .padding(.bottom, 4)
    }
}

#if DEBUG
struct RoundedBadge_Previews : PreviewProvider {
    static var previews: some View {
        RoundedBadge(text: "Test", color: .blue)
    }
}
#endif
