//
//  EntryError.swift
//  CloudKitJournal
//
//  Created by Ben Erekson on 8/9/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation

enum EntryError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    
    var errorDescription: String {
        switch self {
        
        case .ckError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Could not unwrap object"
        }
    
}
}
