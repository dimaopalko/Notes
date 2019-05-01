//
//  DetailsViewController.swift
//  Notes
//
//  Created by Dima Opalko on 4/29/19.
//  Copyright © 2019 Dima Opalko. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var previousVC = NotesTableViewController()
    var selectedNote: NoteCoreData?
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func shareButton(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [textView?.text as Any], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: Any) {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let note = selectedNote {
                context.delete(note)
            }
            let note = NoteCoreData(entity: NoteCoreData.entity(), insertInto: context)
            
            note.noteDescription = textView.text
            
            try? context.save()
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Note"
        textView.text = selectedNote?.noteDescription
    }
}
