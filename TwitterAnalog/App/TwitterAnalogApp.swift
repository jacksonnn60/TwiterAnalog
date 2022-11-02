//
//  TwitterAnalogApp.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

@main
struct TwitterAnalogApp: App {
        
    let signUpViewModel = SignUpViewModel(authService: .shared)
    
    var body: some Scene {
        WindowGroup {
            SignUpContentView(viewModel: signUpViewModel)
        }
    }
}
