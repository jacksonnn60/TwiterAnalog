//
//  SignInContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

struct SignInContentView: View {
    
    @ObservedObject var viewModel: SignInViewModel
    
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
                    viewModel.signIn(email: email, password: password)
                }
            }
            .navigationDestination(isPresented: $viewModel.userDidSignIn) {
                TabBarContentView()
                    .navigationBarHidden(true)
            }
            .navigationTitle("Sign in")
            .padding()
        }
    }
}

struct SignInContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInContentView(viewModel: .init(authService: .shared))
    }
}
