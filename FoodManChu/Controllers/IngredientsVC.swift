//
//  IngredientsVC.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/11/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit
import CoreData

class IngredientsVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties

    
    //MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        setupIngredientControllerDelegate()
        DataModelService.shared.attemptIngredientFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DataModelService.shared.attemptIngredientFetch()
        tableView.reloadData()
    }
    
    //MARK: - Instance Properties
    
    
    //MARK: - IBActions

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segues.editIngredient {
            if let destinationVC = segue.destination as? IngredientDetailVC {
                if let ingredient = sender as? Ingredient {
                    destinationVC.ingredientToEdit = ingredient
                }
            }
        }
    }
}

//MARK: - Table View Methods

extension IngredientsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = DataModelService.shared.ingredientController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = DataModelService.shared.ingredientController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ingredientCellReuseId) {
            let ingredient = DataModelService.shared.ingredientController.object(at: indexPath)
            cell.textLabel!.text = ingredient.name
            if ingredient.systemGenerated == false {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
                cell.selectionStyle = .none
            }
        return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let objs = DataModelService.shared.ingredientController.fetchedObjects, objs.count > 0 {
            let ingredient = objs[indexPath.row]
            if ingredient.systemGenerated == false {
                performSegue(withIdentifier: Constants.Segues.editIngredient, sender: ingredient)
            }
        }
    }
}

//MARK: - Core Data Methods

extension IngredientsVC: NSFetchedResultsControllerDelegate {
    
    func setupIngredientControllerDelegate() {
        DataModelService.shared.ingredientController.delegate = self
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
