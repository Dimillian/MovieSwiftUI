//
//  ImageService.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import UIKit

class ImageService {
    static let shared = ImageService()
    private static let queue = DispatchQueue(label: "Image queue",
                                     qos: DispatchQoS.userInitiated)
    
    //TODO: Build disk cache too.
    var memCache: [String: UIImage] = [:]
    
    private let lock = NSLock()
    
    enum Size: String {
        case small = "https://image.tmdb.org/t/p/w154/"
        case medium = "https://image.tmdb.org/t/p/w500/"
        case cast = "https://image.tmdb.org/t/p/w185/"
        case original = "https://image.tmdb.org/t/p/original/"
        
        func path(poster: String) -> URL {
            return URL(string: rawValue)!.appendingPathComponent(poster)
        }
    }
    
    enum ImageError: Error {
        case decodingError
    }
    
    func purgeCache() {
        memCache.removeAll()
    }
    
    func syncImageFromCache(poster: String, size: Size) -> UIImage? {
        return memCache[poster]
    }
    
    func fetchImage(poster: String, size: Size) -> AnyPublisher<UIImage?, Never> {
        if let cached = memCache[poster] {
            return Just(cached).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: size.path(poster: poster))
            .tryMap { (data, response) -> UIImage? in
                let image = UIImage(data: data)
                if let image = image {
                    self.lock.lock()
                    self.memCache[poster] = image
                    self.lock.unlock()
                }
                return image
        }.catch { error in
            return Just(nil)
        }
        .eraseToAnyPublisher()
    }
}
