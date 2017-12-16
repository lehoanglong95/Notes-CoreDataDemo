//
//  AddCategoryViewController.swift
//  Notes
//
//  Created by LongLH on 12/15/17.
//  Copyright © 2017 LongLH. All rights reserved.
//

import UIKit
import CoreData

class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    private func setupView() {
        setupBarButtonItem()
    }
    
    private func setupBarButtonItem() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveCategoryName))
        navigationItem.rightBarButtonItems = [rightBarButton]
    }

    @objc private func saveCategoryName() {
        guard let managedObjectContext = managedObjectContext else { return }
        let category = Category(context: managedObjectContext)
        guard let name = categoryNameTextField.text, !name.isEmpty else {
            return
        }
        category.name = name
        navigationController?.popViewController(animated: true)
    }
}
