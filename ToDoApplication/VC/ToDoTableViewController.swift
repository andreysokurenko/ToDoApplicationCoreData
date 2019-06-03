//
//  ToDoTableViewController.swift
//  ToDoApplication
//
//  Created by Andrey on 01.12.2018.
//  Copyright © 2018 Andrey. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    var resultsController: NSFetchedResultsController<Todo>!
    let coreDataStack = CoreDataStack()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sortDescriptors]
        
        
        resultsController = NSFetchedResultsController(fetchRequest: request,
                                                       managedObjectContext: coreDataStack.managedContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        
        resultsController.delegate = self
        
        do {
            try resultsController.performFetch()
        } catch  {
            print("Perfom fetch error: \(error)")
        }
        
    }
    
    

    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].numberOfObjects ?? 0
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let todo = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, complition) in
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            do {
                try self.resultsController.managedObjectContext.save()
                complition(true)

            } catch {
                print("delete failed: \(error)")
            }
            
        }
        
        action.image = UIImage(named: "t.png")
        action.backgroundColor = .red
        
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAddToDo", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, complition) in
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            do {
                try self.resultsController.managedObjectContext.save()
                complition(true)
                
            } catch {
                print("delete failed: \(error)")
                complition(false)
            }
        }
        
        action.image = UIImage(named: "c.png")
        action.backgroundColor = .green
        
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? addToDoViewController {
            vc.managedContext = resultsController.managedObjectContext
        }
        
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? addToDoViewController {
            vc.managedContext = resultsController.managedObjectContext
            if let indexPath = tableView.indexPath(for: cell){
                let todo = resultsController.object(at: indexPath)
                vc.todo = todo
            }
        }
    }
    


}
extension ToDoTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                let todo = resultsController.object(at: indexPath)
                cell.textLabel?.text = todo.title
            }
        default:
            break
        }
    }
}
