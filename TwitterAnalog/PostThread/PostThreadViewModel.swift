//
//  PostThreadViewModel.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 06/11/2022.
//

import Foundation

final class PostThreadViewModel: ObservableViewModel {
    
    @Published var feedbacks: [TwitsService.Feedback] = []
    @Published var post: Post = .init(id: .init(),
                                      ownerID: .init(),
                                      ownerName: "--",
                                      content: "--",
                                      timeInterval: 0.0,
                                      likes: [],
                                      feedbackIDs: []
    )
    
    var isLikedPost: Bool {
        (post.likes ?? []).contains { $0 == AuthService.shared.userInfo?.userID }
    }
    
    func isLikedFeedback(feedback: TwitsService.Feedback) -> Bool {
        (feedback.likes ?? []).contains { $0 == AuthService.shared.userInfo?.userID ?? "" } 
    }
    
    private let twitsService: TwitsService
    
    init(twitsService: TwitsService, selectedPost: Post) {
        self.twitsService = twitsService
        super.init()
        self.post = post
    }
    
    func toggleLike(feedbackID: String) {
        twitsService.toggleFeedbackLike(userID: AuthService.shared.userInfo?.userID ?? "",
                                        feedbackID: feedbackID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.fetchFeedbacks()
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
    func fetchFeedbacks() {
        twitsService.getFeedbacks(for: post.id?.uuidString ?? "") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let feedbacks):
                    self?.feedbacks = feedbacks.sorted { $0.timeInterval ?? 0.0  > $1.timeInterval ?? 0.0 }
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
}
