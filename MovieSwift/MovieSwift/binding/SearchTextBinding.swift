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
    var willChange = PassthroughSubject<SearchTextWrapper, Never>()
    
    @Published var searchText = "" {
        willSet {
            DispatchQueue.main.async {
                self.willChange.send(self)
            }
        }
        didSet {
            DispatchQueue.main.async {
                self.onUpdateText(text: self.searchText)
            }
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
                $0.searchText
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
