//
//  ViewModel.swift
//  TwitterAnalog
//
//  Created by Basistyi, Yevhen on 02/11/2022.
//

import Foundation
import SwiftUI

protocol ViewModel: ObservableObject {
    var requestError: Error? { get }
    var errorDidOccured: Bool { get }
}
