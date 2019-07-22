
//
//  ScrollableSelector.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 22/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ScrollableSelector: View {
    let items: [String]
    @Binding var selection: Int
    
    func text(for index: Int) -> some View {
        Group {
            if index == selection {
                VStack(spacing: 12) {
                    Text(items[index])
                        .foregroundColor(.steam_gold)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .padding(.top, 12)
                        .tapAction {
                            self.selection = index
                    }
                    Rectangle()
                        .frame(height: 2)
                        .padding(.leading, -6)
                        .padding(.trailing, -6)
                        .foregroundColor(.steam_gold)
                }
            } else {
                Text(items[index])
                    .font(.headline)
                    .tapAction {
                        self.selection = index
                }
            }
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 12) {
                ForEach(0 ..< items.count) {
                    self.text(for: $0)
                }
            }
        }.frame(height: 36)
    }
}

#if DEBUG
struct ScrollableSelector_Previews: PreviewProvider {
    static var previews: some View {
        ScrollableSelector(items: ["Menu 1", "Menu 2", "Menu 3",
                                   "Menu 4", "Menu 5", "Menu 6",
                                   "Menu 7", "Menu 8"],
                           selection: .constant(1))
    }
}
#endif
