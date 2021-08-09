//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by Ben Erekson on 8/9/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import CloudKit

class EntryController {
    //Shared Instance
    static var shared = EntryController()
    
    ///Cloud kit default private db
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //SOT
    var entries: [Entry] = []
    
    //MARK: - CRUD Functions
    
    func createEntry(title: String, body: String, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void){
        let entry = Entry(title: title, body: body)
        
        let entryRecord = CKRecord(entry: entry)
        
        privateDB.save(entryRecord) { record, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                  let savedRecord = Entry(ckRecord: record) else { return completion(.failure(.couldNotUnwrap))}
            
            print("Saved Entry sucessfully!")
            self.entries.append(entry)
            completion(.success(savedRecord))
        }
    }
    
    func update(entry: Entry, completion: @escaping (_ result: (Result<Bool,EntryError>)) -> Void) {
        let ckentry = CKRecord(entry: entry)
        let updateRecord = CKModifyRecordsOperation(recordsToSave: [ckentry], recordIDsToDelete: nil)
        updateRecord.savePolicy = .changedKeys
        updateRecord.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
        }
        privateDB.add(updateRecord)
        return completion(.success(true))
    }
    
    func fetchEntries(completion: @escaping(_ result:Result<[Entry]?,EntryError>) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: EntryTypeKeys.recordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
            
            print("Records have been fetched sucessfully")
            
            self.entries = records.compactMap{ Entry(ckRecord: $0) }
            
            completion(.success(self.entries))
            
        }
        
    }
    
}
