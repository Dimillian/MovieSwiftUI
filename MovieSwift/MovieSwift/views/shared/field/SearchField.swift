//
//  SearchField.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 20/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine

struct SearchField : View {
    @ObservedObject var searchTextWrapper: SearchTextObservable
    let placeholder: String
    @Binding var isSearching: Bool
    var dismissButtonTitle: String
    var dismissButtonCallback: (() -> Void)?
    
    private var searchCancellable: Cancellable? = nil
    
    init(searchTextWrapper: SearchTextObservable,
         placeholder: String,
         isSearching: Binding<Bool>,
         dismissButtonTitle: String = "Cancel",
         dismissButtonCallback: (() -> Void)? = nil) {
        self.searchTextWrapper = searchTextWrapper
        self.placeholder = placeholder
        self._isSearching = isSearching
        self.dismissButtonTitle = dismissButtonTitle
        self.dismissButtonCallback = dismissButtonCallback
        
        self.searchCancellable = searchTextWrapper.searchSubject.sink(receiveValue: { value in
            isSearching.wrappedValue = !value.isEmpty
        })
    }
    
    var body: some View {
        return HStack(alignment: .center, spacing: 0) {
            Image(systemName: "magnifyingglass")
            TextField(placeholder,
                      text: $searchTextWrapper.searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.trailing)
            .padding(.leading)
            if !searchTextWrapper.searchText.isEmpty {
                Button(action: {
                    self.searchTextWrapper.searchText = ""
                    self.isSearching = false
                    self.dismissButtonCallback?()
                }, label: {
                    Text(dismissButtonTitle).foregroundColor(.steam_blue)
                }).animation(.easeInOut)
            }
        }
        .padding(4)
        
    }
}

#if DEBUG
struct SearchField_Previews : PreviewProvider {
    static var previews: some View {
        let withText = SearchTextObservable()
        withText.searchText = "Test"
        
        return VStack {
            SearchField(searchTextWrapper: SearchTextObservable(),
                        placeholder: "Search anything",
                        isSearching: .constant(false))
            SearchField(searchTextWrapper: withText,
                        placeholder: "Search anything",
                        isSearching: .constant(false))
            
            List {
                SearchField(searchTextWrapper: withText,
                            placeholder: "Search anything",
                            isSearching: .constant(false))
                Section(header: SearchField(searchTextWrapper: withText,
                                            placeholder: "Search anything",
                                            isSearching: .constant(false)))
                {
                    SearchField(searchTextWrapper: withText,
                                placeholder: "Search anything",
                                isSearching: .constant(false))
                }
            }
            
            List {
                SearchField(searchTextWrapper: withText,
                            placeholder: "Search anything",
                            isSearching: .constant(false))
                Section(header: SearchField(searchTextWrapper: withText,
                                            placeholder: "Search anything",
                                            isSearching: .constant(false)))
                {
                    SearchField(searchTextWrapper: withText,
                                placeholder: "Search anything",
                                isSearching: .constant(false))
                }
            }.listStyle(GroupedListStyle())
        }
    }
}
#endif
