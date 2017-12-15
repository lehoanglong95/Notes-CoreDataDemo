//
//  CategoriesViewController.swift
//  Notes
//
//  Created by LongLH on 12/15/17.
//  Copyright © 2017 LongLH. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController {
    
    private enum Segue {
        static let AddCategory = "AddCategory"
        static let Category = "Category"
    }

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var note: Note?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        guard let managedObjectContext = note?.managedObjectContext else {
            fatalError("Unable to access managed Object Context")
        }
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Category.name), ascending: false)]
        let fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResults
    }()
    
    private var hasCategories: Bool {
        guard let categories =  fetchedResultsController.fetchedObjects else {
            return false
        }
        return categories.count > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = "You dont have any categories"
        fetchRequest()
    }
    
    private func updateView() {
        messageLabel.isHidden = hasCategories
        tableView.isHidden = !hasCategories
    }
    
    private func fetchRequest() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("Can not fetch Request with \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case Segue.AddCategory:
            print("abc")
        case Segue.Category:
            print("xyz")
        default:
            break
        }
    }

}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        configure(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let deletedCategory: Category = fetchedResultsController.object(at: indexPath)
        note?.managedObjectContext?.delete(deletedCategory)
    }
    
    private func configure(_ cell: CategoryTableViewCell, at indexPath: IndexPath) {
        let category: Category = fetchedResultsController.object(at: indexPath)
        cell.name.text = category.name
    }
    
}
