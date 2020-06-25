//
//  ViewRecipeVC.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/23/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit

class ViewRecipeVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shortDescLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var cookingInstructionsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Properties
    
    var recipe: Recipe!
    var recipeIngredients: [Ingredient] = []
    
    
    
    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        // set up tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        // updateUI
        updateUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    
    //MARK: - Instance Methods
    
    func updateUI() {
        
        nameLabel.text = recipe.name
        shortDescLabel.text = recipe.shortDesc
        print(recipe.shortDesc)
        prepTimeLabel.text = "\(Int(recipe.prepTimeInMins))"
        cookingInstructionsLabel.text = recipe.cookingInstructions
        
        if let ingredients = recipe.ingredient {
            for ingredient in ingredients {
                recipeIngredients.append(ingredient as! Ingredient)
            }
        }
    }
    
    
    //MARK: - IBActions
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.editRecipeFromView {
            let destinationVC = segue.destination as! RecipeDetailVC
            destinationVC.recipeToEdit = recipe
            destinationVC.delegate = self
        }
    }
    

}


//MARK: - TableView Methods

extension ViewRecipeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.recipeCellReuseId,
                                                 for: indexPath) as! CustomCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: CustomCell, indexPath: IndexPath) {
        let ingredient = recipeIngredients[indexPath.row]
        cell.textLabel?.text = ingredient.name
    }
}


//MARK: - ShareRecipeDelegate

extension ViewRecipeVC: ShareRecipeDelegate {
    func shareRecipe(_ recipe: Recipe) {
        self.recipe = recipe
        updateUI()
    }
}
