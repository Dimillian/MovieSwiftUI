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
    var didChange = PassthroughSubject<SearchTextWrapper, Never>()
    
    @Published var searchText = "" {
        didSet {
            self.onUpdateText(text: searchText)
            didChange.send(self)
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
        searchCancellable = didChange.eraseToAnyPublisher()
            .map {
                $0.$$searchText.value
        }
        .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink(receiveValue: { (searchText) in
                self.onUpdateTextDebounced(text: searchText)
            })
    }
    
    func onUpdateText(text: String) {
        /// Overwrite by your subclass to get instant text update.
    }
    
    func onUpdateTextDebounced(text: String) {
        /// Overwrite by your subclass to get debounced text update.
    }
}
