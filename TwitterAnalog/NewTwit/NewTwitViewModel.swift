//
//  NewTwitViewModel.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 06/11/2022.
//

import SwiftUI

final class NewTwitViewModel: ObservableViewModel {
    
    private let twitsService: TwitsService
    
    @Published var twitContext: String = ""
    
    init(twitsService: TwitsService) {
        self.twitsService = twitsService
    }
    
    func createPost(completed: @escaping (Bool) -> ()) {
        guard !twitContext.isEmpty else {
            return
        }
        
        twitsService.createPost(
            with: .init(ownerID: AuthService.shared.userInfo?.userID ?? "",
                        ownerName: AuthService.shared.userInfo?.userName ?? "--",
                        content: twitContext)
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completed(false)
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
    
}
