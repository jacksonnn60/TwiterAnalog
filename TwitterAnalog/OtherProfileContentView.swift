//
//  OtherProfileContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 26/10/2022.
//

import SwiftUI

struct OtherProfileContentView: View {
    
    var twitService = TwitsService(httpClient: .init(urlSession: .shared))
    var followersService = FollowersService(httpClient: .init(urlSession: .shared))
    
    let searchedPerson: SearchedPerson
    
    @State var posts: [Post] = []
    
    @State var isFollowedSearchedPerson: Bool = false
    
    @State var userInfo: UserInfo? = nil
        
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Image("back")
                    .resizable()
                    .frame(height: proxy.size.height * 0.2)
                    .overlay {
                        Image(systemName: "person.circle")
                            .resizable()
                            .background(Color.white)
                            .frame(width: 84, height: 84)
                            .clipShape(Circle())
//                            .overlay(content: {
//                                Circle().stroke(Color.white)
//                            })
                            .offset(CGSize(width: 0, height: 15))
                            .foregroundColor(.blue)
                    }
                    
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(searchedPerson.name)
                            .font(.system(size: 26, weight: .semibold))
                        Text("About person information")
                            .font(.system(size: 15))
                        
                        HStack(spacing: 5) {
                            HStack(spacing: 5) {
                                Text("\(userInfo?.folowingsIDs.count ?? 0)")
                                    .font(.system(size: 13, weight: .semibold))
                                Text("folowings")
                                    .font(.system(size: 13))
                                    .foregroundColor(.primary)
                                    .onTapGesture {
                                        
                                    }
                            }
                            HStack(spacing: 5) {
                                Text("\(userInfo?.folowersIDs.count ?? 0)")
                                    .font(.system(size: 13, weight: .semibold))
                                Text("folowers")
                                    .font(.system(size: 13))
                                    .foregroundColor(.primary)
                                    .onTapGesture {
                                        
                                    }
                            }
                            HStack(spacing: 5) {
                                Text("\(posts.count)")
                                    .font(.system(size: 13, weight: .semibold))
                                Text("twits")
                                    .font(.system(size: 12))
                            }
                        }
                        .padding(.top, 1)
                
                    }
                    
                    Spacer()
                    
                    if isFollowedSearchedPerson {
                        Button {
                            followersService.unfollow(followingID: searchedPerson.id, userID: AuthService.shared.userInfo?.userID ?? "") { result in
                                switch result {
                                case .success(let userInfo):
                                    isFollowedSearchedPerson = false
                                    self.userInfo = userInfo
                                case .failure(let failure): print(failure)
                                }
                            }
                        } label: {
                            Text("unfollow")
                                .padding([.leading, .trailing], 16)
                                .padding([.top, .bottom], 5)
                                .foregroundStyle(.white)
                                .bold()
                        }
                        .background(.red)
                        .cornerRadius(6.0)

                    } else {
                        Button {
                            followersService.follow(followingID: searchedPerson.id, userID: AuthService.shared.userInfo?.userID ?? "") { result in
                                switch result {
                                case .success(let userInfo):
                                    isFollowedSearchedPerson = true
                                    self.userInfo = userInfo
                                case .failure(let failure): print(failure)
                                }
                            }
                        } label: {
                            Text("follow")
                                .padding([.leading, .trailing], 16)
                                .padding([.top, .bottom], 5)
                                .foregroundStyle(.white)
                                .bold()
                        }
                        .background(.blue)
                        .cornerRadius(6.0)
                    }
                    
                }
                .padding([.leading, .trailing], 16)
                
                List {
                    ForEach(posts) {
                        TwitRowView(post: $0, hearButtonDidTap: { post in
                            twitService.toggleLike(
                                userID: AuthService.shared.userInfo?.userID ?? "",
                                twitID: post.id?.uuidString ?? "") { result in
                                    
                                switch result {
                                case .success:
                                    
                                    twitService.getFreshPosts(by: AuthService.shared.userInfo?.userID ?? .init()) { result in
                                        switch result {
                                        case .success(let posts):
                                            self.posts = posts
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
            .onAppear {
                withAnimation {
                    AuthService.shared.getUserInfo(userID: searchedPerson.id) { result in
                        switch result {
                        case .success(let userInfo):
                            self.userInfo = userInfo
                            
                            isFollowedSearchedPerson = AuthService.shared.userInfo?.folowingsIDs
                                .contains(where: {$0 == searchedPerson.id}) ?? false
                            
                            twitService.getPosts(by: searchedPerson.id) { result in
                                switch result {
                                case .success(let posts): self.posts = posts
                                case .failure(let error): print(error)
                                }
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
}

struct OtherProfileContentView_Previews: PreviewProvider {
    static var previews: some View {
        OtherProfileContentView(searchedPerson: .init(id: .init(), name: "Tailor"), posts: [.init(id: .init(), ownerID: .init(), ownerName: "Name", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", timeInterval: 0.0, likes: [], feedbackIDs: [])]
        )
    }
}
