//
//  IngredientDetailVC.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/11/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit

class IngredientDetailVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var ingredientTextField: UITextField!
    
    
    //MARK: - Properties
    var ingredientToEdit: Ingredient?
    
    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        if ingredientToEdit != nil {
            ingredientTextField.text = ingredientToEdit?.name
        }
    }
    
    //MARK: - Instance Methods
    
    func validateIngredientName() -> (Bool, String?) {
        
        if let ingredientNameText = ingredientTextField.text {
            if ingredientNameText.isEmpty {
                return (false, "Ingredient name cannot be empty")
            } else {
                // check if the recipe name already exists
                let ingredients = DataModelService.shared.ingredientController.fetchedObjects!
                var ingredientNames: [String] = []
                for ingredient in ingredients {
                    ingredientNames.append(ingredient.name!)
                }
                if ingredientNames.contains(ingredientNameText) {
                    return (false, "Ingredient name already exists")
                }
            }
        }
        return (true, nil)
    }
    
    func displayError( error: (doesNotExists: Bool, message: String?) ) {
        if error.doesNotExists {
            return
        } else {
            // set up alert and dsplay
            let alert = UIAlertController(title: error.message, message: "Please correct and try again", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true) {
                self.ingredientTextField.becomeFirstResponder()
            }
        }
    }

    
    
    //MARK: - IBActions
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        guard let name = ingredientTextField.text, !name.isEmpty else { return }
        
        var ingredient: Ingredient!
        
        if ingredientToEdit != nil {
            ingredient = ingredientToEdit
            // check if the updated recipe name now conflicts with another existing recipe
            if name != ingredient.name {
                let validIngredientName: (Bool, String?) = validateIngredientName()
                if !validIngredientName.0 {
                    displayError(error: validIngredientName)
                    return
                }
            }
        } else {
            // for a new ingredient, check for valid ingredient name
            let validIngredientName: (Bool, String?) = validateIngredientName()
            if !validIngredientName.0 {
                displayError(error: validIngredientName)
                return
            }
            ingredient = Ingredient(context: Constants.context)
        }
        
        ingredient.name = name
        
        Constants.ad.saveContext()
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func deleteTapped(_ sender: RoundButton) {
        
        if ingredientToEdit != nil {
            Constants.context.delete(ingredientToEdit!)
            Constants.ad.saveContext()
            navigationController?.popViewController(animated: true)
        } else {
            ingredientTextField.text = ""
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
