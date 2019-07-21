//
//  SearchTextBinding.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine

class SearchTextWrapper: BindableObject {
    var willChange = PassthroughSubject<String, Never>()
    
    var searchText = "" {
        willSet {
            willChange.send(newValue)
        }
        didSet {
            onUpdateText(text: searchText)
        }
    }
    
    private var searchCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    deinit {
        searchCancellable?.cancel()
    }
    
    init() {
        searchCancellable = willChange.eraseToAnyPublisher()
            .map {
                $0
        }
        .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink(receiveValue: { (searchText) in
                DispatchQueue.main.async {
                    self.onUpdateTextDebounced(text: searchText)
                }
            })
    }
    
    func onUpdateText(text: String) {
        /// Overwrite by your subclass to get instant text update.
    }
    
    func onUpdateTextDebounced(text: String) {
        /// Overwrite by your subclass to get debounced text update.
    }
}
