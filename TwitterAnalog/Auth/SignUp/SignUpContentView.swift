//
//  ContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

struct SignUpContentView<ViewModel: SignUpViewModel>: View {
    
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
                TextField("Login", text: $viewModel.login)
                    .textFieldStyle(.roundedBorder)
                    .speechSpellsOutCharacters(false)
                    .textInputAutocapitalization(.never)
                Spacer()

                Button("Sign up") {
                    viewModel.signUp()
                }
                .padding(.bottom)
                
                NavigationLink {
                    SignInContentView(viewModel: .init(authService: .shared))
                } label: {
                    Text("Already have account")
                        .font(.system(size: 12, weight: .semibold))
                }
                
            }
            .alert(String(describing: viewModel.requestError ?? "Something went wrong"),
                   isPresented: $viewModel.errorDidOccured) {
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
