//
//  WindowType.swift
//  JustTags
//
//  Created by Yurii Zadoianchuk on 29/04/2023.
//

import Foundation

private let scheme = "justtags"

enum WindowType {
    
    case main
    case diff
    case library
    
    var eventIdentifier: String {
        switch self {
        case .main:
            return "main"
        case .diff:
            return "diff"
        case .library:
            return "lookup"
        }
    }
    
    var url: URL {
        URL(string: "\(scheme)://\(eventIdentifier)")!
    }
}
