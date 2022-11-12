//
//  Response.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import Foundation

struct ServerResponse<T: Codable>: Codable {
    let code: UInt
    let message: String?
    let data: T?
}
