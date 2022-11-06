//
//  SignInViewModel.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 02/11/2022.
//

import Foundation

import SwiftUI

final class SignInViewModel: ObservableViewModel {
    
    @Published var userDidSignIn = false
    @Published var email = ""
    @Published var password = ""
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func signIn() {
        authService.signIn(with: .init(email: email, password: password)) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success: self?.userDidSignIn = true
                case .failure(let error): self?.error = error
                }
            }
        }
    }
    
}
