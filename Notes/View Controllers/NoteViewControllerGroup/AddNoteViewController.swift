//
//  AddNoteViewController.swift
//  Notes
//
//  Created by LongLH on 12/12/17.
//  Copyright © 2017 LongLH. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {

    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func save(_ sender: Any) {
        guard let managedObjectContext = managedObjectContext else { return }
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(with: "Title Missing", and: "Your note doesn't have a title")
            return
        }
        let note = Note(context: managedObjectContext)
        note.createdAt = Date()
        note.updatedAt = Date()
        note.title = titleTextField.text
        note.contents = contentsTextView.text

        navigationController?.popViewController(animated: true)
    }
}

extension UIViewController {
    func showAlert(with title: String, and message: String) {
       let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
