//
//  MyLists.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MyLists : View {
    @State var selectedList: Int = 0
    
    var body: some View {
        NavigationView {
            List {
                SegmentedControl(selection: $selectedList) {
                    Text("Wishlist").tag(0)
                    Text("Seen").tag(1)
                }
            }
            .navigationBarTitle(Text("My Lists"))
        }
    }
}

#if DEBUG
struct MyLists_Previews : PreviewProvider {
    static var previews: some View {
        MyLists(selectedList: 0)
    }
}
#endif
