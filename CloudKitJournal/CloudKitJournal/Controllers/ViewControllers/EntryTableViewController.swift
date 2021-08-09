//
//  EntryTableViewController.swift
//  CloudKitJournal
//
//  Created by Ben Erekson on 8/9/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EntryController.shared.entries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = EntryController.shared.entries[indexPath.row]
        
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.timestamp.asString()
        
        return cell
    }
    
    //MARK: - Helper Funcitons
    func updateViews(){
        tableView.reloadData()
    }
    
    func fetchData(){
        EntryController.shared.fetchEntries { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.updateViews()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToDetail" {
            guard let destination = segue.destination as? DetailsViewController,
                  let index = tableView.indexPathForSelectedRow else { return }
            destination.entry = EntryController.shared.entries[index.row]
        }
    }
    
}
