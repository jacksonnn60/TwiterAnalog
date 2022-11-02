//
//  NewTwitContentView.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 26/10/2022.
//

import SwiftUI

struct NewTwitContentView: View {
    
    var twitService: TwitsService = TwitsService(httpClient: .init(urlSession: .shared))
    
    @State private var twitContext: String = ""
    
    @Binding var isPresented: Bool
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                HStack(alignment: .top) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 54, height: 54)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("New twit")
                            .font(.system(size: 24, weight: .semibold))
                        
                        ZStack(alignment: .leading) {
                            if twitContext.isEmpty {
                                VStack {
                                    Text("Write something...")
                                        .padding(.top, 10)
                                        .padding(.leading, 6)
                                    Spacer()
                                }
                            }
                            VStack {
                                TextEditor(text: $twitContext)
                                    .frame(minHeight: 75, maxHeight: 300)
                                    .opacity(twitContext.isEmpty ? 0.75 : 1)
                                Spacer()
                            }
                        }
                        .padding(.top, -10)
                        .padding(.trailing, 10)
                        .frame(height: 75)
                    }.padding(.leading)
                }.padding(.leading)
                
                Button {
                    twitService.createPost(
                        with: .init(ownerID: AuthService.shared.userInfo?.userID ?? "",
                                    ownerName: AuthService.shared.userInfo?.userName ?? "--",
                                    content: twitContext)
                    ) {
                        switch $0 {
                        case .success: isPresented = false
                        case .failure(let error): print(error)
                        }
                    }
                } label: {
                    Text("Post")
                        .font(.system(size: 18))
                }
                .frame(width: proxy.size.width * 0.6)
                .foregroundColor(.blue)
                
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(height: 0.5)
                    .padding([.leading, .top, .trailing])
            }
            .padding(.top)
        }
    }
}

struct NewTwitContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewTwitContentView(isPresented: .constant(false))
    }
}
