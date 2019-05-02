//
//  AddOrDetailsViewController.swift
//  Notes
//
//  Created by Dima Opalko on 4/28/19.
//  Copyright © 2019 Dima Opalko. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextViewDelegate {
    
    var previousVC = NotesTableViewController()
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func saveButton(_ sender: Any) {
        if textView.text != "Enter text here!" {
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                let note = NoteCoreData(entity: NoteCoreData.entity(), insertInto: context)
                if let text = textView.text {
                    
                    note.noteDescription = text
                    
                    try? context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        } else {
            let alertController = UIAlertController(title: "Enter text or I will punch you in the neck!", message: nil, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "Ok!", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Note"
        textView.text = "Enter text here!"
        textView.textColor = UIColor.lightGray
        textView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter text here!"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

