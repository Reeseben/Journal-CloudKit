//
//  DetailsViewController.swift
//  CloudKitJournal
//
//  Created by Ben Erekson on 8/9/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var timeStampLable: UILabel!
    @IBOutlet var bodyText: UITextView!
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: - Properties
    var entry: Entry?
    
    //MARK: - Helper Functions
    func updateViews(){
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        timeStampLable.text = entry.timestamp.asString()
        bodyText.text = entry.body
    }
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
              let body = bodyText.text, !body.isEmpty else { return }
        
        if let entry = entry {
            entry.title = title
            entry.body = body
            entry.timestamp = Date()
            
            EntryController.shared.update(entry: entry) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("Sucsess!")
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        } else {
            EntryController.shared.createEntry(title: title, body: body) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("Entry Sucessfully created.")
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print("Error saving entry: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
}
