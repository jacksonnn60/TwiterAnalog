//
//  SignInContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

struct SignInContentView: View {
    
    let authService = AuthService.shared
    @Binding var isLoggedIn: Bool
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .speechSpellsOutCharacters(false)
                    .textInputAutocapitalization(.never)
                TextField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .speechSpellsOutCharacters(false)
                    .textInputAutocapitalization(.never)
                Spacer()
                
                Button("Sign In") {
                    authService.signIn(with: .init(email: email, password: password)) {
                        switch $0 {
                        case .success: isLoggedIn = true
                        case .failure(let error): print(error)
                        }
                    }
                }
            }
            .navigationTitle("Sign in")
            .padding()
        }
    }
}

struct SignInContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInContentView(isLoggedIn: .init(projectedValue: .constant(false)))
    }
}
