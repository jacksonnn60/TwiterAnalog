//
//  TwitterAnalogApp.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

@main
struct TwitterAnalogApp: App {
    
    @State private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                TabBarContentView()
            } else {
                SignUpContentView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
