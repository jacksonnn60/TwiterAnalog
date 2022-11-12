//
//  Request.swift
//  IMDBAppUIKit
//
//  Created by Jackson  on 10/06/2022.
//

import Foundation

// MARK: - URLS

enum URLs {
    static let baseURL = "https://imdb-api.com/API/"
    static let localhostURL = "http://127.0.0.1:8080"
}

enum Constants {
//    static let apiKey = "k_hof2qn0u"
}


// MARK: - Request

protocol Request {
    var request: URLRequest { get }
}

extension Request where Self: RequestDetails {
    var request: URLRequest {
        var urlRequest = URLRequest(url: urlComponent.url!)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = body
        return urlRequest
    }
}

// MARK: - RequestDetails

protocol RequestDetails {
    var httpMethod: HTTPMethod { get }
    var urlComponent: URLComponents { get }
    var headers: [String: String] { get }
    var body: Data? { get }

    var path: String { get }
//    var url: String { get }
}

extension RequestDetails {
    var headers: [String : String] {
        var headers: [String: String] = [:]
        headers.updateValue(HeaderValue.contentType.rawValue, forKey: HeaderKey.contentType.rawValue)
        return headers
    }

    var urlComponent: URLComponents {
        return URLComponents(string: URLs.localhostURL + path)!
    }
}
