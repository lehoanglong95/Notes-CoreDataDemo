//
//  ViewController.swift
//  Notes
//
//  Created by LongLH on 12/11/17.
//  Copyright © 2017 LongLH. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var notes: [Note]? {
        didSet {
            updateView()
            tableView.reloadData()
        }
    }
    
    var notesDidChange: Bool = false {
        didSet {
            notes?.sort(by: { (note0, note1) -> Bool in
                note0.updatedAtAsDate > note1.updatedAtAsDate
            })
            tableView.reloadData()
            updateView()
        }
    }
    
    private enum Segue {
        static let AddNote = "AddNote"
        static let EditNote = "EditNote"
    }
    
    private var hasNotes: Bool {
        guard let notes = notes else {
            return false
        }
        return notes.count > 0
    }
    
    private lazy var updatedAtDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter
    }()
    
    private let coreDataManager = CoreDataManager(modelName: "Notes")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setupUserInterface()
        
        setupView()
        fetchNotes()
        setupNotificationHandling()
    }
    
    private func setupUserInterface() {
        title = "Notes"
        messageLabel.text = "You dont have any notes here"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case Segue.AddNote:
            guard let destination = segue.destination as? AddNoteViewController else { return }
            destination.managedObjectContext = self.coreDataManager.managedObjectContext
        case Segue.EditNote:
            guard let destination = segue.destination as? NoteViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow, let notes = notes else {
                return
            }
            destination.note = notes[indexPath.row]
        default:
            break
        }
    }
    
    private func updateView() {
        tableView.isHidden = !hasNotes
        messageLabel.isHidden = hasNotes
    }
    
    private func setupView() {
        
    }
    
    private func setupNotificationHandling() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidChange(_:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: coreDataManager.managedObjectContext)
    }
    
    @objc func managedObjectContextDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            for insert in inserts {
                if let note = insert as? Note {
                    notes?.append(note)
                    notesDidChange = true
                }
            }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            for update in updates {
                if let _ = update as? Note {
                    notesDidChange = true
                }
            }
        }
        
        if let deleted = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            for delete in deleted {
                if let index = notes?.index(of: delete as! Note) {
                    notes?.remove(at: index)
                    notesDidChange = true
                }
            }
        }
    }
    
    private func fetchNotes() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        coreDataManager.managedObjectContext.performAndWait {
            do {
                let notes = try fetchRequest.execute()
                self.notes = notes
            } catch {
                let fetchError = error as NSError
                print("Unable to Excute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageLabel.text = "You dont have any notes here"
        guard let notes = notes else {
            return 0
        }
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier) as! NoteTableViewCell
        guard let notes = notes else {
            fatalError("Unexpected Index Path")
        }
        cell.titleLabel.text = notes[indexPath.row].title
        cell.contentesLabel.text = notes[indexPath.row].contents
        cell.updateAtLabel.text = updatedAtDateFormatter.string(from: notes[indexPath.row].updatedAtAsDate)
        return cell
    }
}

