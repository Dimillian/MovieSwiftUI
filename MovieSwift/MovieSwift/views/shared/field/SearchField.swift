//
//  SearchField.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 20/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct SearchField : View {
    @Binding var searchText: String
    let placeholder: Text
    let onUpdateSearchText: (String) -> Void
    
    func onKeyStroke() {
        onUpdateSearchText(searchText)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: -10) {
            Image(systemName: "magnifyingglass")
            TextField("Search any movies",
                      text: $searchText)
                .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)
                    .debounce(for: .milliseconds(200),
                              scheduler: DispatchQueue.main),
                           perform: onKeyStroke)
                .textFieldStyle(.roundedBorder)
                .listRowInsets(EdgeInsets())
                .padding()
            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                }, label: {
                    Text("cancel").color(.steam_blue)
                }).animation(.basic())
            }
        }
    }
}

#if DEBUG
struct SearchField_Previews : PreviewProvider {
    static var previews: some View {
        SearchField(searchText: .constant("Searched text"),
                    placeholder: Text("Search anything"),
                    onUpdateSearchText: {text in
            
        })
    }
}
#endif
