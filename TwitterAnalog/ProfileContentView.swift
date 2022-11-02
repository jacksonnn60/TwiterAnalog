//
//  ProfileContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

struct ProfileContentView: View {
    
    private var twitService: TwitsService = TwitsService(httpClient: .init(urlSession: .shared))
    @State private var isPresentedNewTwitSheet: Bool = false
    @State private var myPosts: [Post] = []
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                Image("back")
                    .resizable()
                    .frame(height: proxy.size.height * 0.2)
                    .overlay {
                        Image(systemName: "person.circle")
                            .resizable()
                            .background(Color.white)
                            .frame(width: 84, height: 84)
                            .clipShape(Circle())
//                            .overlay {
//                                Circle().stroke(Color.white)
//                            }
                            .offset(CGSize(width: 0, height: 15))
                            .foregroundColor(.blue)
                    }
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(AuthService.shared.userInfo?.userName ?? "Nickname")
                            .font(.system(size: 26, weight: .semibold))
                        Text("About person information")
                            .font(.system(size: 15))
                        
                        HStack(spacing: 5) {
                            HStack(spacing: 5) {
                                Text("\(AuthService.shared.userInfo?.folowingsIDs.count ?? 0)")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.primary)
                                Text("folowings")
                                    .font(.system(size: 13))
                                    .foregroundColor(.primary)
                                    .onTapGesture {
                                        
                                    }
                            }
                            HStack(spacing: 5) {
                                Text("\(AuthService.shared.userInfo?.folowersIDs.count ?? 0)")
                                    .font(.system(size: 13, weight: .semibold))
                                Text("folowers")
                                    .font(.system(size: 13))
                                    .foregroundColor(.primary)
                                    .onTapGesture {
                                        
                                    }
                            }
                            HStack(spacing: 5) {
                                Text("\(myPosts.count)")
                                    .font(.system(size: 13, weight: .semibold))
                                Text("twits")
                                    .font(.system(size: 13))
                            }
                        }
                        .padding(.top, 1)
                    }
                    .padding(.leading, 16)
                }
                
                List {
                    ForEach(myPosts) {
                        TwitRowView(post: $0, hearButtonDidTap: { post in
                            twitService.toggleLike(
                                userID: AuthService.shared.userInfo?.userID ?? "",
                                twitID: post.id?.uuidString ?? "") { result in
                                    
                                switch result {
                                case .success:
                                    
                                    twitService.getPosts(by: AuthService.shared.userInfo?.userID ?? .init()) { result in
                                        switch result {
                                        case .success(let posts):
                                            self.myPosts = posts
                                                .sorted { $0.timeInterval ?? 0.0  > $1.timeInterval ?? 0.0 }
                                        case .failure(let failure):
                                            print(failure)
                                        }
                                    }
                                    
                                case .failure(let failure):
                                    print(failure)
                                }
                            }
                        })
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollIndicators(.never)
                .listStyle(.plain)
            }
            .ignoresSafeArea(edges: .top)
            .overlay {
                Button {
                    // TODO: Add new twit...
                    isPresentedNewTwitSheet = true
                } label: {
                    Circle()
                        .frame(width: 64.0, height: 64.0)
                        .overlay {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.white)
                                .font(.system(size: 38, weight: .regular))
                        }
                        .shadow(radius: 3)
                }
                .offset(.init(width: proxy.size.width / 2 - 48, height: proxy.size.height / 2 - 48))
            }
            .sheet(isPresented: $isPresentedNewTwitSheet, onDismiss: {
                withAnimation {
                    twitService.getPosts(by: AuthService.shared.userInfo?.userID ?? "") { result in
                        switch result {
                        case .success(let posts): myPosts = posts
                        case .failure(let error): print(error)
                        }
                    }
                }
            }, content: {
                NewTwitContentView(isPresented: $isPresentedNewTwitSheet)
            })
            .onAppear {
                withAnimation {
                    // TODO: Get posts by real id...
                    AuthService.shared.getUserInfo(userID: AuthService.shared.userInfo?.userID ?? "") { result in
                        switch result {
                        case .success(let userInfo):
                            AuthService.shared.userInfo = userInfo
                            
                            twitService.getPosts(by: AuthService.shared.userInfo?.userID ?? "") { result in
                                switch result {
                                case .success(let posts):
                                    myPosts = posts
                                case .failure(let error): print(error)
                                }
                            }
                        case .failure(let error): print(error)
                        }
                    }
                }
            }
        }
    }
}

struct ProfileContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileContentView()
    }
}
