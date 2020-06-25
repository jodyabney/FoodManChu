//
//  ChooseIngredientTVC.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/12/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit
import CoreData

class ChooseIngredientTVC: UITableViewController {
    
    //MARK: - IBOutlets
    
    
    
    //MARK: - Properties
    var recipe: Recipe!
    var recipeIngredients: [Ingredient]!
    var availableIngredients: [Ingredient] = []
    var controller: NSFetchedResultsController<Ingredient>!
    
    var delegate: ChooseIngredientDelegate?
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attemptFetch()
        
        if let sections = controller.sections {
            availableIngredients = sections[0].objects as! [Ingredient]
        }
        
        if recipeIngredients != nil {
            for ingredient in recipeIngredients {
                availableIngredients.remove(at: availableIngredients.firstIndex(of: ingredient)!)
            }
        } else {
            recipeIngredients = []
        }
        
        tableView.reloadData()
        
        
        
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let delegate = delegate {
            delegate.shareSelectedIngredients(recipeIngredients)
        }
        
        super.viewWillDisappear(true)
    }
    
    //MARK: - Instance Methods
    
    
    
    //MARK: - IBActions
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return recipeIngredients.count
        } else {
            return availableIngredients.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ingredientCellReuseId) {
            if indexPath.section == 0 && recipeIngredients.count > 0 {
                let ingredient = recipeIngredients[indexPath.row]
                cell.textLabel!.text = ingredient.name
                cell.accessoryType = .checkmark
                return cell
            } else {
                let ingredient = availableIngredients[indexPath.row]
                cell.textLabel!.text = ingredient.name
                cell.accessoryType = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Ingredients in Recipe"
        } else {
            return "Available Ingredients"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            availableIngredients.append(recipeIngredients.remove(at: indexPath.row))
            availableIngredients.sort { (lhsIngredient: Ingredient, rhsIngredient: Ingredient) -> Bool in
                return lhsIngredient.name! < rhsIngredient.name!
            }
        } else {
            recipeIngredients.append(availableIngredients.remove(at: indexPath.row))
            recipeIngredients.sort(by: { (lhs: Ingredient, rhs: Ingredient) -> Bool in
                return lhs.name! < rhs.name!
            })
        }
        tableView.reloadData()
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//MARK: - Core Data Methods

extension ChooseIngredientTVC: NSFetchedResultsControllerDelegate {
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: Constants.context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        self.controller = controller
        
        do {
            try controller.performFetch()
        } catch let err {
            print(err)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath)
                let ingredient = controller.object(at: indexPath) as! Ingredient
                cell?.textLabel?.text = ingredient.name
            }
        case .move:
            if let indexPath = indexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        @unknown default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
