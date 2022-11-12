//
//  HeaderValue.swift
//  IMDBAppUIKit
//
//  Created by Jackson  on 10/06/2022.
//

import Foundation

enum HeaderKey: String {
    case contentType = "Content-Type"
    case accessToken = "Authorization"
}


enum HeaderValue: String {
    case contentType = "application/json"
    case multiformData = "multipart/form-data"
}
