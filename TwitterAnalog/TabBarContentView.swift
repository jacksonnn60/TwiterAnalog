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
            FreshTwitsContentView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ProfileContentView()
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
