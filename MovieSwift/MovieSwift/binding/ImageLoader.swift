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
    let didChange = PassthroughSubject<UIImage?, Never>()
    
    let poster: String?
    let size: ImageService.Size
    
    var image: UIImage? = nil {
        didSet {
            didChange.send(image)
        }
    }
    
    init(poster: String?, size: ImageService.Size) {
        self.size = size
        self.poster = poster
    }
    
    func loadImage() {
        guard let poster = poster else {
            return
        }
        ImageService.shared.image(poster: poster, size: .medium) { (result) in
            do { self.image = try result.get() } catch { }
        }
    }
}
