//
//  RecipeDetailTVC.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/12/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit

class RecipeDetailVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var recipeDescription: UITextView!
    @IBOutlet weak var recipePrepTimeInMins: UITextField!
    @IBOutlet weak var cookingInstructions: UITextView!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var duplicateButton: RoundButton!
    @IBOutlet weak var deleteButton: RoundButton!
    
    //MARK: - Properties
    var recipeIngredients = Set<Ingredient>()
    var recipeIngredientsArray: [Ingredient] = []
    var recipeCategory: CategoryType!

    var recipeToEdit: Recipe?
    
    var delegate: ShareRecipeDelegate?
    
    //MARK: - TODO: Deal with deleting an ingredient while creating/editing a recipe
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up category picker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        DataModelService.shared.attemptCategoryTypeFetch()
        
        if recipeToEdit != nil {
            loadRecipe(recipeToEdit!)
            duplicateButton.isEnabled = true
            duplicateButton.backgroundColor = .systemBlue
        } else {
            duplicateButton.isEnabled = false
            duplicateButton.backgroundColor = .systemGray
            categoryPicker.selectRow(0, inComponent: 0, animated: true)
            recipeCategory = DataModelService.shared.categoryTypeController.fetchedObjects?.first
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // handle dismissing the keyboard
        let tap = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    //MARK: - Instance Methods
    
    func loadRecipe(_ recipe: Recipe) {
        recipeName.text = recipe.name
        recipeDescription.text = recipe.shortDesc
        recipePrepTimeInMins.text = String(recipe.prepTimeInMins)
        cookingInstructions.text = recipe.cookingInstructions
        recipeCategory = recipe.categoryType
        if recipeCategory != nil {
            if let sections = DataModelService.shared.categoryTypeController.sections {
                if let sectionInfo = sections.first {
                    if let categories = sectionInfo.objects as? [CategoryType] {
                        let categoryIndexNum = categories.firstIndex(of: recipeCategory)
                        categoryPicker.selectRow(categoryIndexNum!, inComponent: 0, animated: true)
                    }
                }
            }
        }
        
        if let ingredients = recipe.ingredient, ingredients.count > 0 {
            recipeIngredients = (ingredients as? Set<Ingredient>)!
            setRecipeIngredientsArray()
        }
    }
    
    func setRecipeIngredientsArray() {
        
        if recipeIngredients.count > 0 {
            for ingredient in recipeIngredients {
                recipeIngredientsArray.append(ingredient)
            }
            recipeIngredientsArray.sort()
        } else {
            recipeIngredientsArray = []
        }
        
    }
    
    func saveRecipe() {
        
        var recipe: Recipe!

        if recipeToEdit != nil {
            recipe = recipeToEdit
            // handle the case where a user changes the name of the recipe to one that already exists
            if recipeToEdit?.name != recipeName.text {
                let validRecipeName: (Bool, String?) = validateRecipeName()
                if !validRecipeName.0 {
                    displayError(error: validRecipeName)
                    return
                }
            }
        } else {
            // for a new recipe, check for valid recipe name
            let validRecipeName: (Bool, String?) = validateRecipeName()
            if !validRecipeName.0 {
                displayError(error: validRecipeName)
                return
            }
            recipe = Recipe(context: Constants.context)
        }

        recipe.name = recipeName.text
        recipe.shortDesc = recipeDescription.text
        if let prepTimeInMins = Int(recipePrepTimeInMins.text ?? "0") {
            recipe.prepTimeInMins = Int16(prepTimeInMins)
        }
        recipe.cookingInstructions = cookingInstructions.text
        recipe.categoryType = recipeCategory
        // check for any deleted ingredients while creating/editing a recipe
        if recipeIngredientsArray.count > 0 {
            let validIngredients = DataModelService.shared.ingredientController.fetchedObjects!
            var arrayIndex = recipeIngredientsArray.count - 1
            while arrayIndex >= 0 {
                // remove an deleted ingredient
                if (validIngredients.firstIndex(of: recipeIngredientsArray[arrayIndex]) == nil) {
                    recipeIngredientsArray.remove(at: arrayIndex)
                }
                arrayIndex -= 1
            }
        }
        recipe.ingredient = Set(recipeIngredientsArray.map{ $0 } ) as NSSet
        
        Constants.ad.saveContext()
    }
    
    func validateRecipeName() -> (Bool, String?) {
        
        if let recipeNameText = recipeName.text {
            if recipeNameText.isEmpty {
                return (false, "Recipe name cannot be empty")
            } else {
                // check if the recipe name already exists
                let recipes = DataModelService.shared.recipeController.fetchedObjects!
                var recipeNames: [String] = []
                for recipe in recipes {
                    recipeNames.append(recipe.name!)
                }
                if recipeNames.contains(recipeNameText) {
                    return (false, "Recipe name already exists")
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
                self.recipeName.becomeFirstResponder()
            }
        }
    }
    
    
    //MARK: - IBActions
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        
        saveRecipe()
        navigationController?.popViewController(animated: true)
        
    }

    
    @IBAction func deleteRecipeTapped(_ sender: RoundButton) {
        
        // if existing recipe, delete it
        if recipeToEdit != nil {
            Constants.context.delete(recipeToEdit!)
            Constants.ad.saveContext()
            navigationController?.popViewController(animated: true)
        } else {
        // clear the new recipe fields 
            recipeName.text = ""
            recipeDescription.text = ""
            recipePrepTimeInMins.text = "0"
            cookingInstructions.text = ""
            recipeCategory = nil
            categoryPicker.selectRow(0, inComponent: 0, animated: true)
            recipeIngredients = NSSet() as! Set<Ingredient>
            recipeIngredientsArray.removeAll()
            tableView.reloadData()
        }
    }
    
    
    @IBAction func duplicateRecipeTapped(_ sender: RoundButton) {
        
        // save the recipe currently displayed
        saveRecipe()
        // set up the duplicate recipe
        recipeToEdit = nil
        recipeName.text = "\(recipeName.text!) - Copy"
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segues.chooseIngredients {
            let destinationVC = segue.destination as! ChooseIngredientTVC
            destinationVC.recipeIngredients = recipeIngredientsArray
            destinationVC.delegate = self
        }
     }
}


extension RecipeDetailVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let sections = DataModelService.shared.categoryTypeController.sections {
            if let sectionInfo = sections.first {
            return sectionInfo.numberOfObjects
            }
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let sections = DataModelService.shared.categoryTypeController.sections {
            if let sectionInfo = sections.first {
                if let categories = sectionInfo.objects as? [CategoryType] {
                    let category = categories[row]
                    return category.name
                }
            }
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let sections = DataModelService.shared.categoryTypeController.sections {
            if let sectionInfo = sections.first {
                if let categories = sectionInfo.objects as? [CategoryType] {
                    recipeCategory = categories[row]
                }
            }
        }
    }
}


//MARK: - TableView Methods

extension RecipeDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeIngredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ingredientCellReuseId,
                                                                  for: indexPath)
        let ingredient = recipeIngredientsArray[indexPath.row]
        cell.textLabel?.text = ingredient.name
        return cell
    }
}


//MARK: - IngredientSelection Protocol Methods

extension RecipeDetailVC: ChooseIngredientDelegate {

    func shareSelectedIngredients(_ selectedIngredients: [Ingredient]) {

        recipeIngredientsArray.removeAll()
        recipeIngredientsArray = selectedIngredients
        
        tableView.reloadData()
    }
}
