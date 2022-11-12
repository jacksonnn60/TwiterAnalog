//
//  FolowersRequest.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 27/10/2022.
//

import Foundation

enum FolowersRequest: Request, RequestDetails {
    
    case follow(folowingID: String, userID: String)
    case unfollow(folowingID: String, userID: String)
    
    var httpMethod: HTTPMethod {
        switch self {
        case .follow, .unfollow: return .PUT
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
        case .follow(let folowingID, let userID): return "/follow/\(folowingID)/\(userID)"
        case .unfollow(let folowingID, let userID): return "/unfollow/\(folowingID)/\(userID)"
        }
    }
}
