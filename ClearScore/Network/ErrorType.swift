//
//  ErrorType.swift
//  ClearScore
//
//  Created by Eric Sans Alvarez on 07/11/2019.
//  Copyright © 2019 Eric Sans Alvarez. All rights reserved.
//

import Foundation

enum ErrorType: Error {
    case network
    case parsing
    case unknown
}

// Custom error messages

extension ErrorType {
    var localizedDescription: String {
        switch self {
        case .network:
            return "Could not connect with the network. Please check your internet connection"
        case .parsing:
            return "There was an error while parsing the data"
        default:
            return "Don't really know what happened... but I promise I'll figure it out sooner or later!"
        }
    }
}
