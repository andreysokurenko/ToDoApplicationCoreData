//
//  addToDoViewController.swift
//  ToDoApplication
//
//  Created by Andrey on 01.12.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit
import CoreData

class addToDoViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    var todo: Todo?
    
    

    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var segmendedControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buttonConstrain: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        textview.becomeFirstResponder()
        
        if let todo = todo {
            textview.text = todo.title
            textview.text = todo.title

            segmendedControl.selectedSegmentIndex = Int(todo.priotity)
            
        }
        
    }
    
    @objc func keyboardWillShow(with notification: Notification) {
        
        let key = "UIKeyboardFrameEndUserInfoKey"
        
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else {return}
        let keyboardHight = keyboardFrame.cgRectValue.height
        buttonConstrain.constant = keyboardHight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            
        }
    }
    
    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        textview.resignFirstResponder()
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        dismissAndResign()
        
        
    }
    
    
    @IBAction func doneAction(_ sender: UIButton) {
        
        guard let title = textview.text, !title.isEmpty else {
            return
        }
        
        if let todo = self.todo {
            todo.title = title
            todo.priotity = Int16(segmendedControl.selectedSegmentIndex)
        } else {
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priotity = Int16(segmendedControl.selectedSegmentIndex)
            todo.date = Date()
        }
        do {
            try managedContext.save()
            dismissAndResign()

        } catch  {
            print("Error saving to do: \(error)")
        }
        
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

extension addToDoViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if doneButton.isHidden {
            
            textview.text.removeAll()
            
            textview.textColor = .white
            
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    
}
