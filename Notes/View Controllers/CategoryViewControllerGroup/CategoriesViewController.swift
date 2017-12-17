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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let fetchedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResults.delegate = self
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
        tableView.delegate = self
        tableView.dataSource = self
        messageLabel.text = "You dont have any categories"
        fetchRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
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

    @IBAction func addCategory(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let addCategoryVc = storyBoard.instantiateViewController(withIdentifier: "AddCategoryViewController") as! AddCategoryViewController
        addCategoryVc.managedObjectContext = self.note?.managedObjectContext
        navigationController?.pushViewController(addCategoryVc, animated: true)
    }
}

extension CategoriesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        cell.accessoryType = .detailDisclosureButton
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
        cell.name.textColor = category.color
//        if note?.category == category {
//            cell.name.textColor = .bitterSweet
//        } else {
//            cell.name.textColor = .black
//        }
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = fetchedResultsController.object(at: indexPath)
        note?.category = category
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let categoryVc = storyBoard.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        categoryVc.category = fetchedResultsController.object(at: indexPath)
        navigationController?.pushViewController(categoryVc, animated: true)
    }
}

extension CategoriesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
                configure(cell, at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
}
