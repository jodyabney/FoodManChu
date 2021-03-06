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
        // cancel the ingredient controller delegate when the HomeVC view is not displayed
        DataModelService.shared.ingredientController.delegate = nil
        super.viewDidDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // set up the ingredient controller delegate
        setupIngredientControllerDelegate()
        searchForRecipes()
    }
    
    //MARK: - Instance Methods
    
    func searchForRecipes() {
        // ensure we have text in the searchBar
        guard let searchText = searchBar.text else { return }
        // set which search option is selected
        let selectedSearchOption = searchTypeControl.selectedSegmentIndex
        // set up a search results array
        searchResults = []
        // establish a set to ensure we only have unique recipe results
        var uniqueResults = Set<Recipe>()
        
        let recipeRequest = NSFetchRequest<Recipe>(entityName: "Recipe")
        let ingredientRequest = NSFetchRequest<Ingredient>(entityName: "Ingredient")
        let categoryRequest = NSFetchRequest<CategoryType>(entityName: "CategoryType")
        let searchPredicate: NSPredicate
        
        do { // perform the search
            switch selectedSearchOption {
            case 0: // ingredient search
                if searchText != "" { // add a predicate if searchBar contains text
                    searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
                    ingredientRequest.predicate = searchPredicate
                }
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
                if searchText != "" { // add a predicate if searchBar contains text
                    searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
                    recipeRequest.predicate = searchPredicate
                }
                searchResults = try Constants.context.fetch(recipeRequest)
            case 2: // recipe description
                if searchText != "" { // add a predicate if searchBar contains text
                    searchPredicate = NSPredicate(format: "shortDesc CONTAINS[cd] %@", searchText)
                    recipeRequest.predicate = searchPredicate
                }
                searchResults = try Constants.context.fetch(recipeRequest)
            case 3: // prep time in mins
                if searchText != "" { // add a predicate if searchBar contains text
                    searchPredicate = NSPredicate(format: "prepTimeInMins <= %i", Int16(searchText) ?? -999)
                    recipeRequest.predicate = searchPredicate
                }
                searchResults = try Constants.context.fetch(recipeRequest)
            case 4: // category type
                if searchText != "" {
                    searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
                    categoryRequest.predicate = searchPredicate
                }
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
            searchResults.sort { (lhsRecipe: Recipe, rhsRecipe: Recipe) -> Bool in
                return lhsRecipe.name! < rhsRecipe.name!
            }
            
            tableView.reloadData()
            
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    func resetSearch() {
        searchBar.text = nil
        searchResults = []
    }
    
    
    //MARK: - IBActions
    
    @IBAction func searchSegmentedControllerChanges(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: // ingredient
            resetSearch()
            DataModelService.shared.attemptIngredientFetch()
            tableView.reloadData()
        case 1: // recipe name
            resetSearch()
            DataModelService.shared.attemptRecipeFetch()
            tableView.reloadData()
        case 2: // recipe description
            resetSearch()
            DataModelService.shared.attemptRecipeFetch()
            tableView.reloadData()
        case 3: // recipe time
            resetSearch()
            DataModelService.shared.attemptRecipeFetch()
            tableView.reloadData()
        case 4: // category type
            resetSearch()
            DataModelService.shared.attemptCategoryTypeFetch()
            tableView.reloadData()
        default:
            resetSearch()
            tableView.reloadData()
        }
    }
    
    
    @IBAction func searchTapped(_ sender: RoundButton) {
        searchForRecipes()
    }
    
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.viewRecipe {
            let destinationVC = segue.destination as! ViewRecipeVC
            destinationVC.recipe = sender as? Recipe
            // set the destination VC title to the recipe name
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
