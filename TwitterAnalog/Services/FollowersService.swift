//
//  FollowersService.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 27/10/2022.
//

import Foundation

final class FollowersService {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func follow(followingID: String, userID: String, completion: @escaping (Result<UserInfo, Error>) -> ()) {
        httpClient.execute(FolowersRequest.follow(folowingID: followingID, userID: userID)) { (result: Result<ServerResponse<String>, Error>) in
            switch result {
            case .success:
                AuthService.shared.getUserInfo(userID: userID) {
                    switch $0 {
                    case .failure(let failure):
                        completion(.failure(failure))
                    case .success(let userInfo):
                        AuthService.shared.userInfo = userInfo
                        completion(.success(userInfo))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func unfollow(followingID: String, userID: String, completion: @escaping (Result<UserInfo, Error>) -> ()) {
        httpClient.execute(FolowersRequest.unfollow(folowingID: followingID, userID: userID)) { (result: Result<ServerResponse<String>, Error>) in
            switch result {
            case .success:
                AuthService.shared.getUserInfo(userID: userID) {
                    switch $0 {
                    case .failure(let failure):
                        completion(.failure(failure))
                    case .success(let userInfo):
                        AuthService.shared.userInfo = userInfo
                        completion(.success(userInfo))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
