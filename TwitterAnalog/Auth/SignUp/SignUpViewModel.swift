//
//  SignUpViewModel.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 02/11/2022.
//

import Foundation
import SwiftUI

final class SignUpViewModel: ObservableObject {
    
    @Published var userDidSignUp: Bool = .init(false)
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func signUp(email: String, login: String, password: String) {
        authService.signUp(with: .init(email: email, password: password, login: login)) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.userDidSignUp = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
