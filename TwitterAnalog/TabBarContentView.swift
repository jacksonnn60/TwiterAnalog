//
//  TabBarContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

struct TabBarContentView: View {
    var body: some View {
        TabView {
            FreshTwitsContentView(viewModel: .init(searchService: .init(httpClient: .init(urlSession: .shared)), twitsService: .init(httpClient: .init(urlSession: .shared))))
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ProfileContentView(viewModel: .init(twitsService: .init(httpClient: .init(urlSession: .shared))))
                .tabItem {
                    Label("Me", systemImage: "person")
                }
            SettingsContentView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct TabBarContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarContentView()
    }
}
