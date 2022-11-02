//
//  SignUpViewModel.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 02/11/2022.
//

import Foundation
import SwiftUI

final class SignUpViewModel: ViewModel {
    
    var requestError: Error? = nil {
        didSet {
            guard requestError != nil else {
                return
            }
            errorDidOccured = true
        }
    }
    @Published var errorDidOccured: Bool = false
    
    @Published var userDidSignUp = false
    @Published var email = ""
    @Published var password = ""
    @Published var login = ""
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func signUp() {
        authService.signUp(with: .init(email: email, password: password, login: login)) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success: self?.userDidSignUp = true
                case .failure(let error): self?.requestError = error
                }
            }
        }
    }
    
}
