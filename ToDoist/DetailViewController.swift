//
//  DetailViewController.swift
//  ToDoist
//
//  Created by Everett Brothers on 10/31/23.
//

import UIKit

protocol DetailViewControllerDelegate {
    func editedItem(_:DetailViewController,newItem:Item,for indexPath:IndexPath)
    func markAsCompleted(_:DetailViewController,for indexPath:IndexPath,with item: Item)
}

class DetailViewController: UIViewController {

    var delegate: DetailViewControllerDelegate?
    
    var item: Item!
    var indexPath: IndexPath!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    func updateUI() {
        title = item.title
        titleField.text = item.title
        createdLabel.text = item.createdAt?.formatted(date: .abbreviated, time: .standard)
        if let date = item.completedAt {
            completedLabel.text = date.formatted(date: .abbreviated, time: .standard)
        } else {
            completedLabel.text = "Not Completed"
        }
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        guard let text = titleField.text else { return }
        item.title = text
        delegate?.editedItem(self, newItem: item, for: indexPath)
        updateUI()
    }
    
    @IBAction func markClicked(_ sender: Any) {
        item.completedAt = Date.now
        delegate?.markAsCompleted(self, for: indexPath, with: item)
        updateUI()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
