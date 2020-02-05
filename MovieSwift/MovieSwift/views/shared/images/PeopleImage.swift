//
//  PeopleImage.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 06/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct PeopleImage : View {
    @ObservedObject var imageLoader: ImageLoader
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .renderingMode(.original)
                    .cornerRadius(10)
                    .frame(width: 60, height: 90)
            } else {
                Rectangle()
                    .cornerRadius(10)
                    .frame(width: 60, height: 90)
                    .foregroundColor(.gray)
                    .opacity(0.1)
            }
        }
    }
}


struct BigPeopleImage : View {
    @ObservedObject var imageLoader: ImageLoader
    
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .renderingMode(.original)
                    .cornerRadius(10)
                    .frame(width: 100, height: 150)
            } else {
                Rectangle()
                    .cornerRadius(10)
                    .frame(width: 100, height: 150)
                    .foregroundColor(.gray)
                    .opacity(0.1)
            }
        }
    }
}
