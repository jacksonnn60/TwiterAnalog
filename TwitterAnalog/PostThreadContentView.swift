//
//  PostThreadContentVIew.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 31/10/2022.
//

import SwiftUI

struct PostThreadContentView: View {
    
    @State var post: Post = .init(id: .init(), ownerID: .init(), ownerName: "--", content: "--", timeInterval: 0.0, likes: [], feedbackIDs: [])
    
    let twitService = TwitsService(httpClient: .init(urlSession: .init(configuration: .default)))
    
    @State var feedbacks: [TwitsService.Feedback] = []
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.blue)
                    Text(post.ownerName)
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                    Text(Date(timeIntervalSince1970: post.timeInterval ?? 0).getString(formated: .default))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding([.leading, .trailing])
                
                Text(post.content)
                    .padding([.leading, .trailing])
                
                HStack(spacing: 30) {
                    
                    HStack(spacing: 3) {
                        Text("\(post.likes?.count ?? 0)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        let isLiked = (post.likes ?? []).contains(where: {$0 == AuthService.shared.userInfo?.userID})
                        
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .frame(width: 22, height: 22)
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                            .onTapGesture {
//                                twitService.toggleLike(userID: AuthService.shared.userInfo?.userID ?? "", twitID: post.id?.uuidString ?? "") {
//                                    switch $0 {
//                                    case .success:
//                                        twitService.getPosts(by: AuthService.shared.userInfo?.userID ?? "") { result in
//                                            switch result {
//                                            case .success(let posts):
//                                                posts.forEach { post in
//                                                    if post.id == self.post.id {
//                                                        self.post = post
//                                                    }
//                                                }
//                                            case .failure(let failure): print(failure)
//                                            }
//                                        }
//                                    case .failure(let error): print(error)
//                                    }
//                                }
                            }
                    }
                    
                    HStack(spacing: 3) {
                        Text("\(post.feedbackIDs?.count ?? 0)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                        Image(systemName: "bubble.left")
                            .frame(width: 22, height: 22)
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                            .onTapGesture {
                            }
                    }
                }
                
                Rectangle()
                    .foregroundColor(.gray.opacity(0.7))
                    .frame(height: 0.5)
                    .padding([.leading, .trailing], 16)
                    .padding(.top, 8)
                
                Spacer()
                
                
                LazyVGrid(columns: [.init(.flexible(), spacing: 0, alignment: .center)]) {
                    ForEach(feedbacks) { feedback in
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.blue)
                                
                                Text(feedback.ownerName)
                                    .bold()
                                
                                Spacer()
                                
                                Text(Date(timeIntervalSince1970: feedback.timeInterval ?? 0.0).getString(formated: .default))
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                            
                            Text(feedback.feedback)
                            
                            HStack(alignment: .center, spacing: 3) {
                                Text("\(feedback.likes?.count ?? 0)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                let isLiked = (feedback.likes ?? []).contains(where: { $0 == AuthService.shared.userInfo?.userID ?? "" } )
                                
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.gray)
                                    .fontWeight(.semibold)
                                    .onTapGesture {
                                        
                                        twitService.toggleFeedbackLike(userID: AuthService.shared.userInfo?.userID ?? "", feedbackID: feedback.id ?? "") { result in
                                            switch result {
                                            case .success:
                                                withAnimation {
                                                    twitService.getFeedbacks(for: post.id?.uuidString ?? "") { result in
                                                        switch result {
                                                        case .success(let feedbacks): self.feedbacks = feedbacks.sorted { $0.timeInterval ?? 0.0  > $1.timeInterval ?? 0.0 }
                                                        case .failure(let failure): print(failure)
                                                        }
                                                    }
                                                }
                                            case .failure(let failure):
                                                print(failure)
                                            }
                                        }
                                        
                                    }
                            }
                            .frame(maxWidth: .infinity)
                            
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.3))
                                .frame(height: 0.5)
                        }
                    }
                }
                .padding([.leading, .trailing], 16)
                
            }
            .onAppear {
                withAnimation {
                    twitService.getFeedbacks(for: post.id?.uuidString ?? "") { result in
                        switch result {
                        case .success(let feedbacks):
                            self.feedbacks = feedbacks.sorted { $0.timeInterval ?? 0.0  > $1.timeInterval ?? 0.0 }
                        case .failure(let failure): print(failure)
                        }
                    }
                }
            }
        }
    }
}

struct PostThreadContentVIew_Previews: PreviewProvider {
    static var previews: some View {
        PostThreadContentView(post: .init(id: .init(), ownerID: .init(), ownerName: "Yevhen Basistyi", content: "", timeInterval: .init(), likes: .init(), feedbackIDs: .init()))
    }
}
