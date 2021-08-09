//
//  Entry.swift
//  CloudKitJournal
//
//  Created by Ben Erekson on 8/9/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import CloudKit

struct EntryTypeKeys {
    static let recordTypeKey = "Entry"
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
}

class Entry {
    
    var title: String
    var body: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
}

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryTypeKeys.titleKey] as? String,
              let body = ckRecord[EntryTypeKeys.bodyKey] as? String,
              let timestamp = ckRecord[EntryTypeKeys.timestampKey] as? Date else { return nil }
        
        self.init(title: title, body: body, timestamp: timestamp)
        
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryTypeKeys.recordTypeKey, recordID: entry.ckRecordID)
        
        self.setValuesForKeys([
            EntryTypeKeys.titleKey: entry.title,
            EntryTypeKeys.bodyKey: entry.body,
            EntryTypeKeys.timestampKey: entry.timestamp
        ])
    }
}
