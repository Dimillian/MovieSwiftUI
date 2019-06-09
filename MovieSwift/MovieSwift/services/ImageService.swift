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

struct ImageService {
    static let shared = ImageService()
    static let queue = DispatchQueue(label: "Image queue",
                                     qos: DispatchQoS.userInitiated)
    
    enum Size: String {
        case medium = "https://image.tmdb.org/t/p/w500/"
        case original = "https://image.tmdb.org/t/p/original/"
        
        func path(poster: String) -> URL {
            return URL(string: rawValue)!.appendingPathComponent(poster)
        }
    }
    
    enum ImageError: Error {
        case decodingError
    }
    
    func image(poster: String, size: Size, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        ImageService.queue.async {
            do {
                let data = try Data(contentsOf: size.path(poster: poster))
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    if let image = image {
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
