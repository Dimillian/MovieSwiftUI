//
//  OutlineRow.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 27/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct OutlineRow : View {
    let item: OutlineMenu
    @Binding var selectedMenu: OutlineMenu
    
    var isSelected: Bool {
        selectedMenu == item
    }
    
    var body: some View {
        HStack {
            Image(systemName: item.systemImageName())
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(isSelected ? .steam_gold : .white)
            Text(item.title())
                .font(.FjallaOne(size: 24))
                .color(isSelected ? .steam_gold : .white)
            }
            .padding()
            .tapAction {
                self.selectedMenu = self.item
            }
    }
}

#if DEBUG
struct OutlineRow_Previews : PreviewProvider {
    static var previews: some View {
        OutlineRow(item: .popular, selectedMenu: .constant(.popular))
    }
}
#endif
