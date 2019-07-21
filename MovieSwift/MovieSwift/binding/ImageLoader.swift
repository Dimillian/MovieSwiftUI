//
//  ImageData.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

final class ImageLoader: BindableObject {
    let willChange = PassthroughSubject<Void, Never>()
    
    let path: String?
    let size: ImageService.Size
    
    var image: UIImage? = nil {
        willSet {
            if newValue != nil {
                willChange.send()
            }
        }
    }
    
    var cancellable: AnyCancellable?
    
    init(path: String?, size: ImageService.Size) {
        self.size = size
        self.path = path
    }
    
    func loadImage() {
        guard let poster = path else {
            return
        }
        self.cancellable = ImageService.shared.fetchImage(poster: poster, size: .medium)
            .receive(on: DispatchQueue.main)
            .assign(to: \ImageLoader.image, on: self)
    }
    
    deinit {
        cancellable?.cancel()
    }
}
