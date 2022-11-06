//
//  ProfileContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import SwiftUI

struct ProfileContentView<ViewModel: ProfileViewModel>: View {
    
    @ObservedObject var viewModel: ViewModel
    
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
                        Text(viewModel.userInfo.userName)
                            .font(.system(size: 26, weight: .semibold))
                        Text("About person information")
                            .font(.system(size: 15))
                        
                        HStack(spacing: 5) {
                            HStack(spacing: 5) {
                                Text("\(viewModel.userInfo.folowingsIDs.count)")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.primary)
                                Text("folowings")
                                    .font(.system(size: 13))
                                    .foregroundColor(.primary)
                                    .onTapGesture {
                                        
                                    }
                            }
                            HStack(spacing: 5) {
                                Text("\(viewModel.userInfo.folowersIDs.count)")
                                    .font(.system(size: 13, weight: .semibold))
                                Text("folowers")
                                    .font(.system(size: 13))
                                    .foregroundColor(.primary)
                                    .onTapGesture {
                                        
                                    }
                            }
                            HStack(spacing: 5) {
                                Text("\(viewModel.myPosts.count)")
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
                    ForEach(viewModel.myPosts) {
                        TwitRowView(post: $0, hearButtonDidTap: { post in
                            viewModel.toggleLike(twitID: post.id?.uuidString ?? "")
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
                    viewModel.isPresentedNewTwitSheet = true
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
            .sheet(isPresented: $viewModel.isPresentedNewTwitSheet, onDismiss: {
                withAnimation {
                    viewModel.fetchPosts()
                }
            }, content: {
                NewTwitContentView(viewModel: .init(twitsService: .init(httpClient: .init(urlSession: .shared))), isPresented: $viewModel.isPresentedNewTwitSheet)
            })
            .onAppear {
                withAnimation {
                    viewModel.fetchUserInformation()
                }
            }
        }
    }
}

struct ProfileContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileContentView(viewModel: .init(twitsService: .init(httpClient: .init(urlSession: .shared))))
    }
}
