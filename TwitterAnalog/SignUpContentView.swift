//
//  ContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

struct SignUpContentView: View {
    
    let authService = AuthService.shared
    @Binding var isLoggedIn: Bool
    
    @State var email: String = ""
    @State var password: String = ""
    @State var nickname: String = ""
    
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
                TextField("Nickname", text: $nickname)
                    .textFieldStyle(.roundedBorder)
                    .speechSpellsOutCharacters(false)
                    .textInputAutocapitalization(.never)
                Spacer()

                Button("Sign up") {
                    authService.signUp(with: .init(email: email, password: password, login: nickname)) {
                        switch $0 {
                        case .success: isLoggedIn = true
                        case .failure(let error): print(error)
                        }
                    }
                }
                .padding(.bottom)
                
                NavigationLink {
                    SignInContentView(isLoggedIn: $isLoggedIn)
                } label: {
                    Text("Already have account")
                        .font(.system(size: 12, weight: .semibold))
                }

            }
            .navigationTitle("Sign Up")
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpContentView(isLoggedIn: .init(projectedValue: .constant(false)))
    }
}
