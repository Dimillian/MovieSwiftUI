//
//  SettingsForm.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 25/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Foundation

struct SettingsForm : View {
    @State var selectedRegion: Int = 0
    @State var alwaysOriginalTitle: Bool = false
    @Environment(\.isPresented) var isPresented
    
    var countries: [String] {
        get {
            var countries: [String] = []
            for code in NSLocale.isoCountryCodes {
                let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
                let name = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id)!
                countries.append(name)
            }
            return countries
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Region preferences"),
                        footer: Text("Region is used to display a more accurate movies list"),
                        content: {
                        Toggle(isOn: $alwaysOriginalTitle) {
                            Text("Always show original title")
                        }
                        Picker(selection: $selectedRegion,
                               label: Text("Region"),
                               content: {
                                ForEach(0 ..< self.countries.count) {
                                    Text(self.countries[$0]).tag($0)
                                }
                        })
                })
                Section(header: Text("App data"), footer: Text("None of those action are working yet ;)"), content: {
                    Text("Export my data")
                    Text("Backup to iCloud")
                    Text("Restore from iCloud")
                    Text("Reset application data").color(.red)
                })
                
                Section(header: Text("Debug info")) {
                    Text("Image in memory cache: \(ImageService.shared.memCache.count)")
                    Text("Movies in state: \(store.state.moviesState.movies.count)")
                    Text("Archived state size: \(store.state.sizeOfArchivedState())")
                }
                }.onAppear{
                    if let index = NSLocale.isoCountryCodes.firstIndex(of: AppUserDefaults.region) {
                        self.selectedRegion = index
                    }
                    self.alwaysOriginalTitle = AppUserDefaults.alwaysOriginalTitle
                }.navigationBarItems(trailing: Button(action: {
                    AppUserDefaults.region = NSLocale.isoCountryCodes[self.selectedRegion]
                    AppUserDefaults.alwaysOriginalTitle = self.alwaysOriginalTitle
                    self.isPresented?.value = false
                }, label: {
                    Text("Save")
                }))
                .navigationBarTitle(Text("Settings"))
        }
    }
}

#if DEBUG
struct SettingsForm_Previews : PreviewProvider {
    static var previews: some View {
        SettingsForm()
    }
}
#endif
