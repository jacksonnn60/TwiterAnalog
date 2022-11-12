//
//  ErrorResponse.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 12/11/2022.
//

import Foundation

struct ErrorResponse: IModel {
    let error: Bool
    let reason: String
}
