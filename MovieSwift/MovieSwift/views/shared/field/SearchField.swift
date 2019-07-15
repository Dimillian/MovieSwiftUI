//
//  SearchField.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 20/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct SearchField : View {
    @ObjectBinding var searchTextWrapper: SearchTextWrapper
    let placeholder: String
    var dismissButtonTitle = "Cancel"
    var dismissButtonCallback: (() -> Void)?
    
    var body: some View {
        return HStack(alignment: .center, spacing: -10) {
            Image(systemName: "magnifyingglass")
            TextField(placeholder,
                      text: $searchTextWrapper.searchText)
                .textFieldStyle(.roundedBorder)
                .listRowInsets(EdgeInsets())
                .padding()
            if !searchTextWrapper.searchText.isEmpty {
                Button(action: {
                    self.searchTextWrapper.searchText = ""
                    self.dismissButtonCallback?()
                }, label: {
                    Text(dismissButtonTitle).color(.steam_blue)
                }).animation(.basic())
            }
        }
    }
}

#if DEBUG
struct SearchField_Previews : PreviewProvider {
    static var previews: some View {
        SearchField(searchTextWrapper: SearchTextWrapper(),
                    placeholder: "Search anything")
    }
}
#endif
