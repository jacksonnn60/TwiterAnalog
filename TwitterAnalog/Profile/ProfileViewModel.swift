//
//  ProfileViewModel.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 06/11/2022.
//

import SwiftUI

final class ProfileViewModel: ObservableViewModel {
    
    @Published var isPresentedNewTwitSheet: Bool = false
    @Published var myPosts: [Post] = []
    
    private let twitsService: TwitsService
    
    var userInfo: UserInfo {
        AuthService.shared.userInfo ?? .init(userID: "",
                                             userName: "Nickname",
                                             postsIDs: [],
                                             folowingsIDs: [],
                                             folowersIDs: []
        )
    }
    
    init(twitsService: TwitsService) {
        self.twitsService = twitsService
    }
    
    func fetchUserInformation() {
        AuthService.shared.getUserInfo(userID: userInfo.userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userInfo):
                    AuthService.shared.userInfo = userInfo
                    
                    self?.fetchPosts()
                case .failure(let error): self?.error = error
                }
            }
        }
    }
    
    func fetchPosts() {
        twitsService.getPosts(by: userInfo.userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts): self?.myPosts = posts
                case .failure(let error): self?.error = error
                }
            }
        }
    }
    
    func toggleLike(twitID: String) {
        twitsService.toggleLike(userID: userInfo.userID, twitID: twitID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success: self?.fetchPosts()
                case .failure(let error): self?.error = error
                }
            }
        }
    }
}
