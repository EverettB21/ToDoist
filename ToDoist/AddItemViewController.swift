//
//  AddItemViewController.swift
//  ToDoist
//
//  Created by Everett Brothers on 10/31/23.
//

import UIKit

protocol AddItemDelegate {
    func getNewItem(_:AddItemViewController,item:Item)
}

class AddItemViewController: UIViewController {

    var delegate: AddItemDelegate?
    
    @IBOutlet weak var titleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        guard let text = titleField.text else { return }
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        var newItem = Item(context: managedContext)
        newItem.title = text
        newItem.id = "\(text):\(UUID())"
        newItem.createdAt = Date.now
        delegate?.getNewItem(self, item: newItem)
        performSegue(withIdentifier: "unwindToTable", sender: nil)
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
