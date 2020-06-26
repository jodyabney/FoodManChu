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
    @IBOutlet weak var ingredientText: UILabel!
    
    
    //MARK: - Properties
    
    var recipe: Recipe!
    
    
    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if recipe.name == nil {
//            navigationController?.popViewController(animated: true)
//        }
//    }
    
    
    //MARK: - Instance Methods
    
    func updateUI() {
        
        nameLabel.text = recipe.name
        shortDescLabel.text = recipe.shortDesc
        prepTimeLabel.text = "\(Int(recipe.prepTimeInMins))"
        categoryLabel.text = recipe.categoryType?.name
        cookingInstructionsLabel.text = recipe.cookingInstructions
        ingredientText.text = createIngredientText()

    }
    
    func createIngredientText() -> String {
        var ingredientText = ""
        var recipeIngredients: [String] = []
        if let ingredients = recipe.ingredient {
            for i in ingredients {
                recipeIngredients.append((i as! Ingredient).name!)
            }
            recipeIngredients.sort()
            for i in recipeIngredients {
                ingredientText += "\(i)\n"
            }
        }
        return ingredientText
        
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


//MARK: - ShareRecipeDelegate

extension ViewRecipeVC: ShareRecipeDelegate {
    func shareRecipe(_ recipe: Recipe) {
        self.recipe = recipe
        updateUI()
    }
}
