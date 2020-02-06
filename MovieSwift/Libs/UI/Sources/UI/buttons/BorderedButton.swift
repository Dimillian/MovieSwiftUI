//
//  BorderedButton.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 18/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

public struct BorderedButton : View {
    public let text: String
    public let systemImageName: String
    public let color: Color
    public let isOn: Bool
    public let action: () -> Void
    
    public init(text: String, systemImageName: String, color: Color, isOn: Bool, action: @escaping () -> Void) {
        self.text = text
        self.systemImageName = systemImageName
        self.color = color
        self.isOn = isOn
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            self.action()
        }, label: {
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: systemImageName).foregroundColor(isOn ? .white : color)
                Text(text).foregroundColor(isOn ? .white : color)
            }
            })
            .buttonStyle(BorderlessButtonStyle())
            .padding(6)
            .background(RoundedRectangle(cornerRadius: 8)
                .stroke(color, lineWidth: isOn ? 0 : 2)
                .background(isOn ? color : .clear)
                .cornerRadius(8))
    }
}

#if DEBUG
struct BorderedButton_Previews : PreviewProvider {
    static var previews: some View {
        VStack {
            BorderedButton(text: "Add to wishlist",
                           systemImageName: "film",
                           color: .green,
                           isOn: false,
                           action: {
                            
            })
            BorderedButton(text: "Add to wishlist",
                           systemImageName: "film",
                           color: .blue,
                           isOn: true,
                           action: {
                            
            })
        }
    }
}
#endif
