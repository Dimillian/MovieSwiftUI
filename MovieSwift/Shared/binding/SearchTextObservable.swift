//
//  SearchTextBinding.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/07/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine

class SearchTextObservable: ObservableObject {
    @Published var searchText = "" {
        willSet {
            DispatchQueue.main.async {
                self.searchSubject.send(newValue)
            }
        }
        didSet {
            DispatchQueue.main.async {
                self.onUpdateText(text: self.searchText)
            }
        }
    }
        
    let searchSubject = PassthroughSubject<String, Never>()
    
    private var searchCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    deinit {
        searchCancellable?.cancel()
    }
    
    init() {
        searchCancellable = searchSubject.eraseToAnyPublisher()
            .map {
                $0
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
