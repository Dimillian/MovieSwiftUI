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
        return HStack(alignment: .center, spacing: 16) {
            Image(systemName: "magnifyingglass")
            TextField(placeholder,
                      text: $searchTextWrapper.searchText)
            .textFieldStyle(.roundedBorder)
            if !searchTextWrapper.searchText.isEmpty {
                Button(action: {
                    self.searchTextWrapper.searchText = ""
                    self.dismissButtonCallback?()
                }, label: {
                    Text(dismissButtonTitle).color(.steam_blue)
                }).animation(.basic())
            }
        }.padding(4)
    }
}

#if DEBUG
struct SearchField_Previews : PreviewProvider {
    static var previews: some View {
        let withText = SearchTextWrapper()
        withText.searchText = "Test"
        
        return VStack {
            SearchField(searchTextWrapper: SearchTextWrapper(),
                        placeholder: "Search anything")
            SearchField(searchTextWrapper: withText,
                        placeholder: "Search anything")
            
            List {
                SearchField(searchTextWrapper: withText,
                            placeholder: "Search anything")
                Section(header: SearchField(searchTextWrapper: withText,
                                            placeholder: "Search anything"))
                {
                    SearchField(searchTextWrapper: withText,
                                placeholder: "Search anything")
                }
            }
            
            List {
                SearchField(searchTextWrapper: withText,
                            placeholder: "Search anything")
                Section(header: SearchField(searchTextWrapper: withText,
                                            placeholder: "Search anything"))
                {
                    SearchField(searchTextWrapper: withText,
                                placeholder: "Search anything")
                }
            }.listStyle(.grouped)
        }
    }
}
#endif
