//
//  AuthRequest.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import Foundation

enum AuthRequest: Request, RequestDetails {

    struct SignInInformation: IModel {
        let email: String
        let password: String
    }
    struct SignUpInformation: IModel {
        let email: String
        let password: String
        let login: String
    }
    
    
    case enterAccount(authCredentials: AuthRequest.SignInInformation)
    case createAccount(credentials: AuthRequest.SignUpInformation)
    
    var httpMethod: HTTPMethod {
        switch self {
        case .createAccount, .enterAccount: return .POST
        }
    }
    
    var body: Data? {
        switch self {
        case .createAccount(let data): return try? data.encoded()
        case .enterAccount(let data): return try? data.encoded()
        }
    }
    
    
    var path: String {
        switch self {
        case .enterAccount: return "/auth/login"
        case .createAccount: return "/users"
        }
    }
}
