//
//  IModel.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 25/10/2022.
//

import Foundation

protocol IModel: Codable {
    func encoded() throws -> Data
}

extension IModel {
    func encoded() throws -> Data {
        try JSONEncoder().encode(self)
    }
}
