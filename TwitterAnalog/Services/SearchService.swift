//
//  SearchService.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 26/10/2022.
//

import Foundation

final class SearchService {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func searchUsers(with query: String, completion: @escaping (Result<[SearchedPerson], Error>) -> ()) {
        httpClient.execute(UsersRequest.findUsers(query: query), completion: completion)
    }
    
}
