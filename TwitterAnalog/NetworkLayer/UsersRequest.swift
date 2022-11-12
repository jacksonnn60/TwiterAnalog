//
//  UsersRequest.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 26/10/2022.
//

import Foundation

enum UsersRequest: Request, RequestDetails {
    
    case findUsers(query: String)
    case getInfo(userID: String)
//    case createAccount(credentials: AuthRequest.SignUpInformation)
    
    var httpMethod: HTTPMethod {
        switch self {
        case .findUsers, .getInfo: return .GET
        }
    }
    
    var body: Data? {
        return nil
//        switch self {
//        case .createAccount(let data): return try? data.encoded()
//        case .enterAccount(let data): return try? data.encoded()
//        }
    }
    
    
    var path: String {
        switch self {
        case .findUsers(let query): return "/users/\(query)"
        case .getInfo(let userID): return "/userinfo/\(userID)"
        }
    }
}
