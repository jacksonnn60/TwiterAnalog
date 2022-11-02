//
//  ContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

struct SignUpContentView: View {
    
    @ObservedObject var viewModel: SignUpViewModel
    
//    let authService = AuthService.shared
//    @Binding var isLoggedIn: Bool
    
    @State var email: String = ""
    @State var password: String = ""
    @State var login: String = ""
    
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
                TextField("Nickname", text: $login)
                    .textFieldStyle(.roundedBorder)
                    .speechSpellsOutCharacters(false)
                    .textInputAutocapitalization(.never)
                Spacer()

                Button("Sign up") {
                    viewModel.signUp(email: email, login: login, password: password)
                }
                .padding(.bottom)
                
                NavigationLink {
                    SignInContentView(viewModel: .init(authService: .shared))
                } label: {
                    Text("Already have account")
                        .font(.system(size: 12, weight: .semibold))
                }
                
            }
            .navigationDestination(isPresented: $viewModel.userDidSignUp) {
                TabBarContentView()
                    .navigationBarHidden(true)
            }
            .navigationTitle("Sign Up")
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpContentView(viewModel: .init(authService: .shared))
    }
}
