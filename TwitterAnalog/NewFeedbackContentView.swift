//
//  NewFeedbackContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 01/11/2022.
//

import SwiftUI

struct NewFeedbackContentView: View {
    
    var twitService: TwitsService = TwitsService(httpClient: .init(urlSession: .shared))
    
    @State private var feedback: String = ""
    
    @Binding var isPresented: Bool
    
    let post: Post
     
    var body: some View {
        GeometryReader { proxy in
            VStack {
                
                HStack(alignment: .top) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 54, height: 54)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text(AuthService.shared.userInfo?.userName ?? "User Name")
                            .font(.system(size: 24, weight: .semibold))
                        
                        ZStack(alignment: .leading) {
                            if feedback.isEmpty {
                                VStack {
                                    Text("Reply something...")
                                        .padding(.top, 10)
                                        .padding(.leading, 6)
                                    Spacer()
                                }
                            }
                            VStack {
                                TextEditor(text: $feedback)
                                    .frame(minHeight: 75, maxHeight: 300)
                                    .opacity(feedback.isEmpty ? 0.75 : 1)
                                Spacer()
                            }
                        }
                        .padding(.top, -10)
                        .padding(.trailing, 10)
                        .frame(height: 75)
                    }
                    .padding(.leading)
                }
                .padding([.top, .leading])
                
                Button {
                    twitService.postFeedback(
                        userID: AuthService.shared.userInfo?.userID ?? "",
                        userName: AuthService.shared.userInfo?.userName ?? "",
                        feedback: feedback,
                        postID: post.id?.uuidString ?? "") {
                            switch $0 {
                            case .success: self.isPresented = false
                            case .failure(let failure): print(failure)
                            }
                        }
                } label: {
                    Text("Reply")
                        .font(.system(size: 18))
                }
                .frame(width: proxy.size.width * 0.6)
                .foregroundColor(.blue)
                
                Rectangle()
                    .foregroundColor(.gray.opacity(0.8))
                    .frame(height: 0.5)
                    .padding([.leading, .top, .trailing])
                                
                VStack(alignment: .leading) {
                    Text("Reply to \(post.ownerName) post:")
                        .font(.system(size: 18))
                        .bold()
                    HStack {
                        Text(" - \(post.content)")
                            .font(.system(size: 18))
                    }
                    .padding ([.top, .bottom], 1)
                    
                    Text("wrote on \(Date(timeIntervalSince1970: post.timeInterval ?? 0.0).getString(formated: .default))")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
                .padding([.leading, .top, .trailing])
                
                Rectangle()
                    .foregroundColor(.gray.opacity(0.8))
                    .frame(height: 0.5)
                    .padding([.leading, .top, .trailing])
            }
        }
    }
}

struct NewFeedbackContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewFeedbackContentView(isPresented: .constant(false), post: .init(id: .init(), ownerID: .init(), ownerName: "Yevhen Basistyi", content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ", timeInterval: .init(), likes: .init(), feedbackIDs: .init()))
    }
}
