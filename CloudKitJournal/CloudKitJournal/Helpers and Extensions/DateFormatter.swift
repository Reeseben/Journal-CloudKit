//
//  DateFormatter.swift
//  CloudKitJournal
//
//  Created by Ben Erekson on 8/9/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import Foundation

extension Date {
    func asString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}
