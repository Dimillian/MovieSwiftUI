//
//  DiscoverView.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 19/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct DiscoverView : View {
    @EnvironmentObject var state: AppState
    
    @State var draggedViewState = DraggableCover.DragState.inactive
    
    func scaleResistance() -> CGFloat {
        abs(draggedViewState.translation.width) / 2000
    }
    
    func leftZoneResistance() -> CGFloat {
        -draggedViewState.translation.width / 1000
    }
    
    func rightZoneResistance() -> CGFloat {
        draggedViewState.translation.width / 1000
    }
    
    var zones: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundColor(.green)
                .frame(width: 50, height: UIScreen.main.bounds.height, alignment: .leading)
                .position(x: 25, y: UIScreen.main.bounds.midY)
                .opacity(draggedViewState.isDragging ? 0.3 + Double(leftZoneResistance()) : 0)
                .animation(.basic())
            Rectangle()
                .foregroundColor(.red)
                .frame(width: 50, height: UIScreen.main.bounds.height, alignment: .leading)
                .position(x: UIScreen.main.bounds.width - 25, y: UIScreen.main.bounds.midY)
                .opacity(draggedViewState.isDragging ? 0.3 + Double(rightZoneResistance()) : 0)
                .animation(.basic())
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            zones
            ForEach(state.moviesState.popular.reversed()) {id in
                if self.state.moviesState.popular.firstIndex(of: id) == 0 {
                    DraggableCover(movieId: id, draggedViewState: self.$draggedViewState)
                } else if self.state.moviesState.popular.firstIndex(of: id) == 1 {
                    DiscoverCoverImage(imageLoader: ImageLoader(poster: self.state.moviesState.movies[id]!.poster_path,
                                                                size: .original))
                        .padding(.bottom, Length(self.state.moviesState.popular.firstIndex(of: id)! * 8))
                        .scaleEffect(self.draggedViewState.isDragging ?  1.0 + self.scaleResistance() : 1.0)
                        .animation(.spring())
                } else {
                    DiscoverCoverImage(imageLoader: ImageLoader(poster: self.state.moviesState.movies[id]!.poster_path,
                                                                size: .original))
                        .padding(.bottom, Length(self.state.moviesState.popular.firstIndex(of: id)! * 8))
                        .animation(.spring())
                }
            }
        }
    }
}

#if DEBUG
struct DiscoverView_Previews : PreviewProvider {
    static var previews: some View {
        DiscoverView().environmentObject(sampleStore)
    }
}
#endif
