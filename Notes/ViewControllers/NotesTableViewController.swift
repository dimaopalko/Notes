//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Dima Opalko on 4/28/19.
//  Copyright © 2019 Dima Opalko. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController, UISearchDisplayDelegate {

    // OMG I did a monster supermassive view controller 😱
    // I didn`t find any solution for pagination yet)
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func addButton(_ sender: Any) {
    }
    
    @IBAction func filterButton(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let byAlphabet = UIAlertAction(title: "By alphabet", style: .default, handler: {(alert: UIAlertAction!) in self.filterByAlphabet()})
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(byAlphabet)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion:{})
    }
    
    var notes: [NoteCoreData] = []
    var filteredNoteArray: [NoteCoreData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotes()
    }
    
    func getNotes() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            if let coreDataNotes = try? context.fetch(NoteCoreData.fetchRequest()) as? [NoteCoreData]
            {
                notes = coreDataNotes
                filteredNoteArray = notes
                tableView.reloadData()
            }
        }
    }
    
    func filterByAlphabet(){
        filteredNoteArray = filteredNoteArray.sorted { String($0.noteDescription!) < String($1.noteDescription!) }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNoteArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let noteText = filteredNoteArray[indexPath.row].noteDescription {
            if noteText.count <= 100 {
                cell.textLabel?.text = noteText
            } else {
                cell.textLabel?.text = String(noteText.dropLast(noteText.count - 100)) + "..."
            }
        }
        cell.textLabel?.numberOfLines = 2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = filteredNoteArray[indexPath.row]
        
        performSegue(withIdentifier: "edit", sender: note)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let note = filteredNoteArray[indexPath.row]
                
                context.delete(note)
                filteredNoteArray.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            getNotes()
            tableView.reloadData()
        }
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddViewController {
            addVC.previousVC = self
        }
        if let editVC = segue.destination as? DetailsViewController {
            
            if let selectedNote = sender as? NoteCoreData? {
                editVC.selectedNote = selectedNote
                editVC.previousVC = self
            }
        }
    }
}



extension NotesTableViewController: UISearchBarDelegate {
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            filteredNoteArray = notes
            self.searchBar.endEditing(true)
        } else {
            searchBar.text = ""
            filteredNoteArray = notes
            self.searchBar.endEditing(true)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            
            filteredNoteArray = notes
            
        } else {
            
            filteredNoteArray = notes.filter { ($0.noteDescription?.lowercased().contains(searchText.lowercased()))!
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        self.tableView.reloadData()
    }
}

