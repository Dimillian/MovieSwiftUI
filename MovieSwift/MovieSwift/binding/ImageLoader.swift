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
    
    let path: String?
    let size: ImageService.Size
    
    var image: UIImage? = nil {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self.image)
            }
        }
    }
    
    var missing: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(nil)
            }
        }
    }
    
    init(path: String?, size: ImageService.Size) {
        self.size = size
        self.path = path
    }
    
    func loadImage() {
        guard let poster = path else {
            missing = true
            return
        }
        ImageService.shared.image(poster: poster, size: .medium) { (result) in
            do { self.image = try result.get() } catch { }
        }
    }
}
