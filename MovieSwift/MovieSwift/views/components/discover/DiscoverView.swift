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
    
    var body: some View {
        ZStack(alignment: .center) {
            ForEach(state.moviesState.popular.reversed()) {id in
                if self.state.moviesState.popular.firstIndex(of: id) == 0 {
                    DraggableCover(movieId: id, draggedViewState: self.$draggedViewState)
                } else if self.state.moviesState.popular.firstIndex(of: id) == 1 {
                    DiscoverCoverImage(imageLoader: ImageLoader(poster: self.state.moviesState.movies[id]!.poster_path,
                                                                size: .original))
                        .padding(.bottom, Length(self.state.moviesState.popular.firstIndex(of: id)! * 8))
                        .animation(.fluidSpring())
                        .scaleEffect( self.draggedViewState.isDragging ? 1.0 + self.draggedViewState.translation.width / 2000 :
                        1.0)
                } else {
                    DiscoverCoverImage(imageLoader: ImageLoader(poster: self.state.moviesState.movies[id]!.poster_path,
                                                                size: .original))
                        .padding(.bottom, Length(self.state.moviesState.popular.firstIndex(of: id)! * 8))
                        .animation(.fluidSpring())
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
