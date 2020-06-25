//
//  HomevC.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/8/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var searchTypeControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - Properties
    var searchResults: [Recipe] = []
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableview setup
        tableView.delegate = self
        tableView.dataSource = self
        
        // set up data controller delegates
        setupCategoryControllerDelegate()
        setupIngredientControllerDelegate()
        setupRecipeControllerDelegate()
        
        // handle dismissing the keyboard
        let tap = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false // allow tableview didSelectRow to work
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DataModelService.shared.ingredientController.delegate = nil
        super.viewDidDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupIngredientControllerDelegate()
        
        tableView.reloadData()
    }
    
    //MARK: - Instance Methods
    
    func search() {
        guard let searchText = searchBar.text, searchText != "" else { return }
        let selectedSearchOption = searchTypeControl.selectedSegmentIndex
        searchResults = []
        var uniqueResults = Set<Recipe>()
        
        let recipeRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
        let ingredientRequest = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        let categoryRequest = NSFetchRequest<CategoryType>(entityName: "CategoryType")
        let searchPredicate: NSPredicate
        
        do {
            switch selectedSearchOption {
            case 0: // ingredient search
                searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
                ingredientRequest.predicate = searchPredicate
                let ingredientSearchRequest: [Ingredient] = try Constants.context.fetch(ingredientRequest)
                for ingredient in ingredientSearchRequest {
                    if let recipes = ingredient.recipe?.allObjects as? [Recipe] {
                        for recipe in recipes {
                            uniqueResults.insert(recipe)
                        }
                    }
                }
                searchResults.append(contentsOf: uniqueResults)
            case 1: // recipe name
                searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
                recipeRequest.predicate = searchPredicate
                searchResults = try Constants.context.fetch(recipeRequest)
            case 2: // recipe description
                searchPredicate = NSPredicate(format: "shortDesc CONTAINS[cd] %@", searchText)
                recipeRequest.predicate = searchPredicate
                searchResults = try Constants.context.fetch(recipeRequest)
            case 3: // prep time in mins
                searchPredicate = NSPredicate(format: "prepTimeInMins <= %i", Int16(searchText) ?? -1)
                recipeRequest.predicate = searchPredicate
                searchResults = try Constants.context.fetch(recipeRequest)
            case 4: // category type
                searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
                categoryRequest.predicate = searchPredicate
                let categorySearchResults: [CategoryType] = try Constants.context.fetch(categoryRequest)
                for category in categorySearchResults {
                    if let recipes = category.recipe?.allObjects as? [Recipe] {
                        for recipe in recipes {
                            uniqueResults.insert(recipe)
                        }
                    }
                }
                searchResults.append(contentsOf: uniqueResults)
            default:
                return
            }
            
            tableView.reloadData()
            
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    
    //MARK: - IBActions
    
    @IBAction func searchSegmentedControllerChanges(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: // ingredient
            DataModelService.shared.attemptIngredientFetch()
            tableView.reloadData()
        case 1: // recipe name
            DataModelService.shared.attemptRecipeFetch()
            tableView.reloadData()
        case 2: // recipe description
            DataModelService.shared.attemptRecipeFetch()
            tableView.reloadData()
        case 3: // recipe time
            DataModelService.shared.attemptRecipeFetch()
            tableView.reloadData()
        case 4: // category type
            DataModelService.shared.attemptCategoryTypeFetch()
            tableView.reloadData()
        default:
            break
        }
    }
    
    
    @IBAction func searchTapped(_ sender: RoundButton) {
        
        search()
    }
    
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.viewRecipe {
            let destinationVC = segue.destination as! ViewRecipeVC
            destinationVC.recipe = sender as? Recipe
            destinationVC.title = destinationVC.recipe.name
        }
    }
}


//MARK: - Table View Methods

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.recipeCellReuseId,
                                                       for: indexPath) as? CustomCell else {
                                                        return UITableViewCell()
        }
        configureCell(cell, indexPath: indexPath)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func configureCell(_ cell: CustomCell, indexPath: IndexPath) {
        let recipe = searchResults[indexPath.row]
        cell.configureCell(recipe)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipe = searchResults[indexPath.row]
        performSegue(withIdentifier: Constants.Segues.viewRecipe, sender: recipe)
    }
}


//MARK: - Core Data Methods

extension HomeVC: NSFetchedResultsControllerDelegate {
    
    func setupCategoryControllerDelegate() {
        DataModelService.shared.categoryTypeController.delegate = self
    }
    
    func setupIngredientControllerDelegate() {
        DataModelService.shared.ingredientController.delegate = self
    }
    
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
                let cell = tableView.cellForRow(at: indexPath) as! CustomCell
                configureCell(cell, indexPath: indexPath)
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
