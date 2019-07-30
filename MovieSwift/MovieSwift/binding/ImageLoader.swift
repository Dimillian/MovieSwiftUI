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

class ImageLoaderCache {
    static let shared = ImageLoaderCache()
    
    var loaders: [String: ImageLoader] = [:]
    
    func loaderFor(path: String?, size: ImageService.Size) -> ImageLoader {
        let key = "\(path ?? "missing")#\(size.rawValue)"
        if let loader = loaders[key] {
            return loader
        } else {
            let loader = ImageLoader(path: path, size: size)
            loaders[key] = loader
            return loader
        }
    }
}

final class ImageLoader: ObservableObject {
    let path: String?
    let size: ImageService.Size
    
    @Published var image: UIImage? = nil
    
    var cancellable: AnyCancellable?
    
    init(path: String?, size: ImageService.Size) {
        self.size = size
        self.path = path
    }
    
    func loadImage() {
        guard let poster = path else {
            return
        }
        cancellable = ImageService.shared.fetchImage(poster: poster, size: size)
            .receive(on: DispatchQueue.main)
            .assign(to: \ImageLoader.image, on: self)
    }
    
    deinit {
        cancellable?.cancel()
    }
}
