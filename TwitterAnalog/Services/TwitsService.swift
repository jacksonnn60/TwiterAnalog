//
//  TwitsService.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import Foundation

struct Post: IModel, Identifiable {
    let id: UUID?
    let ownerID: UUID
    let ownerName: String
    let content: String
    let timeInterval: Double?
    let likes: [String]?
    let feedbackIDs: [String]?
}

final class TwitsService {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getPosts(by ownerID: String, completion: @escaping (Result<[Post], Error>) -> ()) {
        httpClient.execute(TwitsRequest.getPosts(ownerID: ownerID)) { (result: Result<ServerResponse<[Post]>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //TODO: End request...
    func getFreshPosts(by userID: String, completion: @escaping (Result<[Post], Error>) -> ()) {
        httpClient.execute(TwitsRequest.getFreshPosts(userID: userID)) { (result: Result<ServerResponse<[Post]>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    struct PostData: IModel {
        let ownerID: String
        let ownerName: String
        let content: String
    }
    
    func createPost(with data: PostData, completion: @escaping (Result<Bool, Error>) -> ()) {
        httpClient.execute(TwitsRequest.createPost(data: data)) { (result: Result<ServerResponse<Post>, Error>) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    struct LikeData: IModel {
        let userID: String
        let postID: String
    }
    
    func toggleLike(userID: String, twitID: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        httpClient.execute(TwitsRequest.likePost(data: .init(userID: userID, postID: twitID))) { (result: Result<ServerResponse<String>, Error>) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    struct FeedbackBody: IModel {
        let ownerID: String
        let postID: String
        let ownerName: String
        let feedback: String
    }
    
    func postFeedback(userID: String, userName: String, feedback: String, postID: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        httpClient.execute(TwitsRequest.postFeedback(data: .init(ownerID: userID, postID: postID, ownerName: userName, feedback: feedback))) { (result: Result<ServerResponse<Feedback>, Error>) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    struct Feedback: IModel, Identifiable {
        let postID: String
        let id: String?
        let feedback: String
        let timeInterval: Double?
        let likes: [String]?
        let ownerID: String
        let ownerName: String
    }
    
    func getFeedbacks(for postID: String, completion: @escaping (Result<[Feedback], Error>) -> ()) {
        httpClient.execute(TwitsRequest.getFeedbacks(postID: postID)) { (result: Result<ServerResponse<[Feedback]>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    struct FeedbackLikeBody: IModel {
        let userID: String
        let feedbackID: String
    }
    
    func toggleFeedbackLike(userID: String, feedbackID: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        httpClient.execute(TwitsRequest.likeFeedback(data: .init(userID: userID, feedbackID: feedbackID))) { (result: Result<ServerResponse<String>, Error>) in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
