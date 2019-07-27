//
//  Font.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 23/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

extension Font {
    public static func FHACondFrenchNC(size: Length) -> Font {
        return Font.custom("FHA Condensed French NC", size: size)
    }
    
    public static func AmericanCaptain(size: Length) -> Font {
        return Font.custom("American Captain", size: size)
    }
    
    public static func FjallaOne(size: Length) -> Font {
        return Font.custom("FjallaOne-Regular", size: size)
    }
}

struct TitleFont: ViewModifier {
    let size: Length
    
    func body(content: Content) -> some View {
        return content.font(.FjallaOne(size: size))
    }
}

extension View {
    func titleFont(size: Length) -> some View {
        return Modified(content: self, modifier: TitleFont(size: size))
    }
    
    func titleStyle() -> some View {
        return Modified(content: self, modifier: TitleFont(size: 16))
    }
}

