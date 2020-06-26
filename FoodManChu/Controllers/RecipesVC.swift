//
//  RecipesVC.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/11/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit
import CoreData

class RecipesVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Properties
    var controller: NSFetchedResultsController<Recipe>!
    
    
    //MARK: - View Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        setupRecipeControllerDelegate()
        DataModelService.shared.attemptRecipeFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DataModelService.shared.attemptRecipeFetch()
        tableView.reloadData()
    }
    
    
    //MARK: - Instance Methods
    
    
    
    //MARK: - IBActions
    
    @IBAction func addNewRecipeTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.Segues.addNewRecipe, sender: self)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.editRecipe {
            if let destinationVC = segue.destination as? RecipeDetailVC {
                if let recipe = sender as? Recipe {
                    destinationVC.recipeToEdit = recipe
                }
            }
        }
    }
}

//MARK: - Table View Methods

extension RecipesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = DataModelService.shared.recipeController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = DataModelService.shared.recipeController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.recipeCellReuseId) {
            let recipe = DataModelService.shared.recipeController.object(at: indexPath)
            cell.textLabel!.text = recipe.name
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let objs = DataModelService.shared.recipeController.fetchedObjects, objs.count > 0 {
            let recipe = objs[indexPath.row]
            performSegue(withIdentifier: Constants.Segues.editRecipe, sender: recipe)
        }
    }
}


//MARK: - Core Data Methods

extension RecipesVC: NSFetchedResultsControllerDelegate {
    
    func setupRecipeControllerDelegate() {
        DataModelService.shared.recipeController.delegate = self
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
                let recipe = controller.object(at: indexPath) as! Recipe
                cell?.textLabel?.text = recipe.name
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
