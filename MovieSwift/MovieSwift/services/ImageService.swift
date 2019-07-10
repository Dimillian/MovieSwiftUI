//
//  ImageService.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 07/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class ImageService {
    static let shared = ImageService()
    private static let queue = DispatchQueue(label: "Image queue",
                                     qos: DispatchQoS.userInitiated)
    
    //TODO: Build disk cache too.
    var memCache: [String: UIImage] = [:]
    
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
    
    // TODO: Prefix memcache with poster size.
    func image(poster: String, size: Size, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = memCache[poster] {
            completionHandler(.success(cachedImage))
            return
        }
        ImageService.queue.async {
            do {
                let data = try Data(contentsOf: size.path(poster: poster))
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    if let image = image {
                        self.memCache[poster] = image
                        completionHandler(.success(image))
                    } else {
                        completionHandler(.failure(ImageError.decodingError))
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }
    }
}
