//
//  SignInViewModel.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 02/11/2022.
//

import Foundation

import SwiftUI

final class SignInViewModel: ObservableObject {
    
    @Published var userDidSignIn: Bool = .init(false)
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func signIn(email: String, password: String) {
        authService.signIn(with: .init(email: email, password: password)) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.userDidSignIn = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
