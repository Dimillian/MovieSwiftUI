//
//  PosterStyle.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct PosterStyle: ViewModifier {
    enum Size {
        case small, medium, big
        
        func width() -> Length {
            switch self {
            case .small: return 100
            case .medium: return 100
            case .big: return 250
            }
        }
        func height() -> Length {
            switch self {
            case .small: return 150
            case .medium: return 150
            case .big: return 375
            }
        }
    }
    
    let loaded: Bool
    let size: Size
    
    func body(content: Content) -> some View {
        return content
            .frame(width: size.width(), height: size.height())
            .cornerRadius(5)
            .opacity(loaded ? 1 : 0.1)
            .shadow(radius: 8)
    }
}

extension View {
    func posterStyle(loaded: Bool, size: PosterStyle.Size) -> some View {
        return Modified(content: self, modifier: PosterStyle(loaded: loaded, size: size))
    }
}
