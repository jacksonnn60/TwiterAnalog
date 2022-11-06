//
//  FreshTwitsContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

struct FreshTwitsContentView<ViewModel: FreshTwitsViewModel>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Find someone to follow...", text: $viewModel.interestedPersonName)
                        .onChange(of: viewModel.interestedPersonName) { query in
                            viewModel.searchUsers()
                        }
                        .textInputAutocapitalization(.never)
                        .speechSpellsOutCharacters(false)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                
                if !viewModel.interestedPeople.isEmpty {
                    List {
                        ForEach(viewModel.interestedPeople) { person in
                            NavigationLink {
                                OtherProfileContentView(searchedPerson: person)
                            } label: {
                                HStack {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 26, height: 26)
                                        .clipShape(Circle())
                                    Text(person.name)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    List {
                        ForEach(viewModel.posts) { post in
                            TwitRowView(post: post, hearButtonDidTap: { post in
                                viewModel.toggleLike(twitID: post.id?.uuidString ?? "")
                            }, chatIconDidTap: { post in
                                viewModel.selectedPost = post
                                viewModel.isPresentedReplyView = true
                            }, showPostThreadButtonDidTap: { post in
                                viewModel.selectedPost = post
                                viewModel.isPresentedPostThread = true
                            })
                            .background(
                                NavigationLink(destination: OtherProfileContentView(searchedPerson: .init(id: post.ownerID.uuidString, name: post.ownerName))) {
                                    EmptyView()
                                }
                                    .opacity(0)
                            )
                        }
                    }
                    .listStyle(.plain)
                }
                
                Spacer()
            }
            .onAppear {
                withAnimation {
                    viewModel.fetchFreshPosts()
                }
            }
            .navigationDestination(isPresented: $viewModel.isPresentedPostThread, destination: {
                if let selectedPost = viewModel.selectedPost {
                    PostThreadContentView(viewModel: .init(twitsService: .init(httpClient: .init(urlSession: .shared)), selectedPost: selectedPost))
                }
            })
            .sheet(isPresented: $viewModel.isPresentedReplyView) {
                viewModel.fetchFreshPosts()
            } content: {
                if let postToReply = viewModel.selectedPost {
                    NewFeedbackContentView(isPresented: $viewModel.isPresentedReplyView, post: postToReply)
                }
            }
        }
    }
}

struct TwitRowView: View {
    
    let post: Post
    
    var hearButtonDidTap: ((Post) -> ())?
    var chatIconDidTap: ((Post) -> ())?
    var showPostThreadButtonDidTap: ((Post) -> ())?
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .top, spacing: 20) {
                
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .foregroundColor(.blue)
                
                VStack(alignment: .trailing) {
                    
                    VStack(alignment: .leading) {
                        
                        HStack(spacing: 5) {
                            Text(post.ownerName)
                                .bold()
                            Spacer()
                            Text(Date(timeIntervalSince1970: post.timeInterval ?? 0.0).getString(formated: .default))
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Text(post.content)
                            .padding(.top, 5)
                        
                        HStack(spacing: 30) {
                            HStack(spacing: 3) {
                                Text("\(post.likes?.count ?? 0)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                let isLiked = (post.likes ?? []).contains { userID in
                                    userID == AuthService.shared.userInfo?.userID
                                }
                                
                                Image(systemName: (isLiked ? "heart.fill" : "heart"))
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.gray)
                                    .fontWeight(.semibold)
                                    .onTapGesture {
                                        hearButtonDidTap?(post)
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
                                        chatIconDidTap?(post)
                                    }
                            }
                        }
                        
                    }
                }
            }
            
            Text("Show post thread")
                .foregroundColor(.blue)
                .onTapGesture {
                    showPostThreadButtonDidTap?(post)
                }
            
            Rectangle()
                .foregroundColor(.gray.opacity(0.3))
                .frame(height: 0.5)
        }
        .listRowBackground(Color.clear)
        .listRowSeparatorTint(.clear)
    }
}

struct FreshTwitsContentView_Previews: PreviewProvider {
    static var previews: some View {
        FreshTwitsContentView(viewModel: .init(searchService: .init(httpClient: .init(urlSession: .shared)), twitsService: .init(httpClient: .init(urlSession: .shared)))
        )
    }
}
