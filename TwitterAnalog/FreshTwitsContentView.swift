//
//  FreshTwitsContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

struct SearchedPerson: IModel, Identifiable {
    let id: String
    let name: String
}

struct FreshTwitsContentView: View {
    
    var searchService: SearchService = SearchService(httpClient: .init(urlSession: .shared))
    var twitsService: TwitsService = TwitsService(httpClient: .init(urlSession: .shared))
    
    // SEARH MODE:
    @State var interestedPersonName: String = ""
    @State var interestedPeople: [SearchedPerson] = []
    
    // TWITS MODE:
    @State var posts: [Post] = []
    @State var isPresentedReplyView = false
    @State var isPresentedPostThread = false
    @State var selectedPost: Post?
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Find someone to follow...", text: $interestedPersonName)
                        .onChange(of: interestedPersonName) { query in
                            if !query.isEmpty {
                                searchService.searchUsers(with: query) { result in
                                    switch result {
                                    case .success(let searchedPeople):
                                        interestedPeople = searchedPeople.filter { $0.id != AuthService.shared.userInfo?.userID ?? "" }
                                    case .failure(let failure):
                                        print(failure)
                                    }
                                }
                            } else {
                                interestedPeople.removeAll()
                            }
                        }
                        .textInputAutocapitalization(.never)
                        .speechSpellsOutCharacters(false)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                
                if !interestedPeople.isEmpty {
                    List {
                        ForEach(interestedPeople) { person in
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
                        ForEach(posts) { post in
                            TwitRowView(post: post, hearButtonDidTap: { post in
                                
                                twitsService.toggleLike(
                                    userID: AuthService.shared.userInfo?.userID ?? "",
                                    twitID: post.id?.uuidString ?? "") { result in
                                        
                                        switch result {
                                        case .success:
                                            
                                            twitsService.getFreshPosts(by: AuthService.shared.userInfo?.userID ?? .init()) { result in
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
                                
                            }, chatIconDidTap: { post in
                                selectedPost = post
                                isPresentedReplyView = true
                            }, showPostThreadButtonDidTap: { post in
                                selectedPost = post
                                isPresentedPostThread = true
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
                    twitsService.getFreshPosts(by: AuthService.shared.userInfo?.userID ?? .init()) { result in
                        switch result {
                        case .success(let posts):
                            self.posts = posts
                                .sorted { $0.timeInterval ?? 0.0  > $1.timeInterval ?? 0.0 }
                        case .failure(let failure):
                            print(failure)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $isPresentedPostThread, destination: {
                if let selectedPost = self.selectedPost {
                    PostThreadContentView(post: selectedPost)
                }
            })
            .sheet(isPresented: $isPresentedReplyView) {
                twitsService.getFreshPosts(by: AuthService.shared.userInfo?.userID ?? .init()) { result in
                    switch result {
                    case .success(let posts):
                        self.posts = posts
                            .sorted { $0.timeInterval ?? 0.0  > $1.timeInterval ?? 0.0 }
                    case .failure(let failure):
                        print(failure)
                    }
                }
            } content: {
                if let postToReply = self.selectedPost {
                    NewFeedbackContentView(isPresented: $isPresentedReplyView, post: postToReply)
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
        FreshTwitsContentView(posts:
                                [
                                    .init(id: .init(), ownerID: .init(), ownerName: "4234 Name", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,", timeInterval: 0.0, likes: [], feedbackIDs: []),
                                    .init(id: .init(), ownerID: .init(), ownerName: "234234 Name", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", timeInterval: 0.0, likes: [], feedbackIDs: [])
                                ]
        )
    }
}
