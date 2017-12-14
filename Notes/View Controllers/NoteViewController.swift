//
//  NoteViewController.swift
//  Notes
//
//  Created by LongLH on 12/14/17.
//  Copyright © 2017 LongLH. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    private func setupUserInterface() {
        if let note = note {
            titleTextField.text = note.title
            contentsTextView.text = note.contents
        }
        contentsTextView.layer.borderWidth = 1
        contentsTextView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
    }
    
}
