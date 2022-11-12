//
//  TwitsRequest.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import Foundation

enum TwitsRequest: Request, RequestDetails {
    
    case getPosts(ownerID: String)
    case getFreshPosts(userID: String)
    case createPost(data: TwitsService.PostData)
    case likePost(data: TwitsService.LikeData)
    
    case getFeedbacks(postID: String)
    case postFeedback(data: TwitsService.FeedbackBody)
    case likeFeedback(data: TwitsService.FeedbackLikeBody)
    
    var httpMethod: HTTPMethod {
        switch self {
        case .createPost, .postFeedback: return .POST
        case .getPosts, .getFreshPosts, .getFeedbacks: return .GET
        case .likePost, .likeFeedback: return .PUT
        }
    }
    
    var body: Data? {
        switch self {
        case .postFeedback(let data): return try? data.encoded()
        case .createPost(let data): return try? data.encoded()
        case .likePost(let data): return try? data.encoded()
        case .likeFeedback(let data): return try? data.encoded()
        default: return nil
        }
    }
    
    var path: String {
        switch self {
        case .getFreshPosts(let userID): return "/posts/fresh/\(userID)"
        case .getPosts(let ownerID): return "/posts/\(ownerID)"
        case .createPost: return "/posts"
        case .likePost: return "/posts/like"
            
        case .postFeedback: return "/feedback"
        case .likeFeedback: return "/feedback/like"
        case .getFeedbacks(let postID): return "/feedback/\(postID)"
        }
    }
    
}
