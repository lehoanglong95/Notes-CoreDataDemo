//
//  NoteViewController.swift
//  Notes
//
//  Created by LongLH on 12/14/17.
//  Copyright © 2017 LongLH. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var categoryName: UILabel!
    
    var note: Note?
    
    private enum Segue {
        static let Categories = "Categories"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationHandling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserInterface()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let title = titleTextField.text, !title.isEmpty {
            note?.title = title
        }
        note?.contents = contentsTextView.text
        note?.updatedAt = Date()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case Segue.Categories:
            guard let destination = segue.destination as? CategoriesViewController else { return }
            guard let note = note else { return }
            destination.note = note
        default:
            break
        }        
    }
    
    @IBAction func edit(_ sender: Any) {
    }
    
    private func setupUserInterface() {
        title = "Edit Note"
        if let note = note {
            titleTextField.text = note.title
            contentsTextView.text = note.contents
            contentsTextView.layer.borderWidth = 1
            contentsTextView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            guard let category = note.category else {
                categoryName.text = "This note doesn't have category"
                return
            }
            categoryName.text = category.name
        }
    }
    
    @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
        
        if (updates.filter { return $0 == note }).count > 0 {
            guard let category = note?.category else {
                categoryName.text = "This note doesn't have category"
                return
            }
            categoryName.text = category.name
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(_:)),
                                       name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: note?.managedObjectContext)
    }
    
}
