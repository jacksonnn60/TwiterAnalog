//
//  AuthService.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import Foundation

struct UserInfo: IModel {
    let userID: String
    let userName: String
    var postsIDs: [String]
    var folowingsIDs: [String]
    var folowersIDs: [String]
}

final class AuthService {
    
    static let shared = AuthService(httpClient: .init(urlSession: .shared))
        
    var userInfo: UserInfo?
    
    let httpClient: HTTPClient
    
    private init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func signUp(with credentials: AuthRequest.SignUpInformation, completion: @escaping (Result<Bool, Error>) -> ()) {
        httpClient.execute(AuthRequest.createAccount(credentials: credentials)) { (result: Result<ServerResponse<UserInfo>, Error>) in
            switch result {
            case .success(let response):
                self.userInfo = response.data
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signIn(with credentials: AuthRequest.SignInInformation, completion: @escaping (Result<Bool, Error>) -> ()) {
        httpClient.execute(AuthRequest.enterAccount(authCredentials: credentials)) { (result: Result<ServerResponse<UserInfo>, Error>) in
            switch result {
            case .success(let response):
                self.userInfo = response.data
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUserInfo(userID: String, completion: @escaping (Result<UserInfo, Error>) -> ()) {
        self.httpClient.execute(UsersRequest.getInfo(userID: userID)) { (result: Result<ServerResponse<UserInfo>, Error>) in
            switch result {
            case .success(let userInfo):
                completion(.success(userInfo.data!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
