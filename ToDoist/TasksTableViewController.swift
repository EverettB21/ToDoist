//
//  TasksTableViewController.swift
//  ToDoist
//
//  Created by Everett Brothers on 10/30/23.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController, AddItemDelegate, DetailViewControllerDelegate {

    var items: [Item] = []
    var selectItem: Item!
    var selectIndex: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ToDoist"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toAddItem))
        getTasks()
    }
    
    @objc func toAddItem() {
        performSegue(withIdentifier: "addItem", sender: nil)
    }
    
    func getNewItem(_: AddItemViewController, item: Item) {
        items.insert(item, at: 0)
        tableView.reloadData()
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
    func markAsCompleted(_: DetailViewController, for indexPath: IndexPath, with item: Item) {
        items[indexPath.row].completedAt = item.completedAt
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        tableView.reloadData()
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
    func editedItem(_: DetailViewController, newItem: Item, for indexPath: IndexPath) {
        items[indexPath.row] = newItem
        tableView.reloadData()
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
    func getTasks() {
        let taskFetch: NSFetchRequest<Item> = Item.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(Item.createdAt), ascending: false)
        taskFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(taskFetch)
            items = results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            vc.delegate = self
            vc.item = selectItem
            vc.indexPath = selectIndex
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectItem = items[indexPath.row]
        selectIndex = indexPath
        performSegue(withIdentifier: "toDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(items[indexPath.row])
            items.remove(at: indexPath.row)
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    @IBSegueAction func addItem(_ coder: NSCoder) -> AddItemViewController? {
        let vc = AddItemViewController(coder: coder)
        vc?.delegate = self
        return vc
    }
    
    @IBAction func unwindToTable(segue: UIStoryboardSegue) {
        
    }
}

extension UITableViewCell {
    func configure(with item: Item) {
        var content = self.defaultContentConfiguration()
        content.text = item.title
        if let _ = item.completedAt {
            self.accessoryType = .checkmark
        }
        self.contentConfiguration = content
    }
}
