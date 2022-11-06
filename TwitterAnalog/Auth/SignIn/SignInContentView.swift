//
//  SignInContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

struct SignInContentView<ViewModel: SignInViewModel>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .speechSpellsOutCharacters(false)
                    .textInputAutocapitalization(.never)
                TextField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                    .speechSpellsOutCharacters(false)
                    .textInputAutocapitalization(.never)
                Spacer()
                
                Button("Sign In") {
                    viewModel.signIn()
                }
            }
            .alert(String(describing: viewModel.error ?? "Something went wrong"),
                   isPresented: $viewModel.errorDidOccured) {
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
