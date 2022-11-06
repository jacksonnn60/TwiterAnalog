//
//  ViewModel.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 02/11/2022.
//

import Foundation
import SwiftUI

protocol ErrorOccurable: AnyObject {
    var error: Error? { get }
    var errorDidOccured: Bool { get }
}

class ObservableViewModel: ErrorOccurable, ObservableObject {
    @Published var errorDidOccured: Bool = false
    
    var error: Error? = nil {
        didSet {
            errorDidOccured = error != nil
        }
    }
}
