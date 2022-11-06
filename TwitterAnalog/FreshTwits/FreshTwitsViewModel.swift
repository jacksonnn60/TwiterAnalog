//
//  FreshTwitsViewModel.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 05/11/2022.
//

import Foundation

final class FreshTwitsViewModel: ObservableViewModel {
    
    private let searchService: SearchService
    private let twitsService: TwitsService
    
    // SEARH MODE:
    @Published var interestedPersonName: String = ""
    @Published var interestedPeople: [SearchService.SearchedPerson] = []
    
    // TWITS MODE:
    @Published var posts: [Post] = []
    @Published var isPresentedReplyView = false
    @Published var isPresentedPostThread = false
    @Published var selectedPost: Post?
    
    init(searchService: SearchService, twitsService: TwitsService) {
        self.searchService = searchService
        self.twitsService = twitsService
    }
    
    func toggleLike(twitID: String) {
        twitsService.toggleLike(userID: AuthService.shared.userInfo?.userID ?? "", twitID: twitID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success: self?.fetchFreshPosts()
                case .failure(let error): self?.error = error
                }
            }
        }
    }
    
    func fetchFreshPosts() {
        twitsService.getFreshPosts(by: AuthService.shared.userInfo?.userID ?? .init()) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts): self?.posts = posts.sorted { $0.timeInterval ?? 0.0  > $1.timeInterval ?? 0.0 }
                case .failure(let error): self?.error = error
                }
            }
        }
    }
    
    func searchUsers() {
        searchService.searchUsers(with: interestedPersonName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let searchedPeople):
                    self?.interestedPeople = searchedPeople.filter { $0.id != AuthService.shared.userInfo?.userID ?? "" }
                case .failure(let error): self?.error = error
                }
            }
        }
    }
    
}
