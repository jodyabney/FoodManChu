//
//  DataModelService.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/17/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import Foundation
import CoreData

class DataModelService {
    
    //MARK: - Singleton
    static var shared = DataModelService()
    
    //MARK: - Properties
    var ingredientController: NSFetchedResultsController<Ingredient>!
    var categoryTypeController: NSFetchedResultsController<CategoryType>!
    var recipeController: NSFetchedResultsController<Recipe>!
    
    //MARK: - Init
    init() {
        // set up the categories
        attemptCategoryTypeFetch()
        if categoryTypeController == nil || categoryTypeController.sections?.count == 0 || categoryTypeController.sections?.first?.numberOfObjects == 0 {
            generateCategoryTypes()
            attemptCategoryTypeFetch()
        }
        
        // set up the ingredients
        attemptIngredientFetch()
        if ingredientController == nil || ingredientController.sections?.count == 0 || ingredientController.sections?.first?.numberOfObjects == 0 {
            generateIngredients()
            attemptIngredientFetch()
        }
        
        // get any existing recipes
        attemptRecipeFetch()
    }
    
    //MARK: - Instance Methods

}

//MARK: - Core Data Methods

extension DataModelService {
    
    func generateCategoryTypes() {
        let category1 = CategoryType(context: Constants.context)
        category1.name = "Meat"
        let category2 = CategoryType(context: Constants.context)
        category2.name = "Vegetarian"
        let category3 = CategoryType(context: Constants.context)
        category3.name = "Vegan"
        let category4 = CategoryType(context: Constants.context)
        category4.name = "Paleo"
        let category5 = CategoryType(context: Constants.context)
        category5.name = "Keto"
        
        Constants.ad.saveContext()
    }
    
    func generateIngredients() {
        let ingredient01 = Ingredient(context: Constants.context)
        ingredient01.name = "Beef, Ground"
        ingredient01.systemGenerated = true
        let ingredient02 = Ingredient(context: Constants.context)
        ingredient02.name = "Chicken"
        ingredient02.systemGenerated = true
        let ingredient03 = Ingredient(context: Constants.context)
        ingredient03.name = "Lettuce"
        ingredient03.systemGenerated = true
        let ingredient04 = Ingredient(context: Constants.context)
        ingredient04.name = "Pepper, Black"
        ingredient04.systemGenerated = true
        let ingredient05 = Ingredient(context: Constants.context)
        ingredient05.name = "Beans, Pinto"
        ingredient05.systemGenerated = true
        let ingredient06 = Ingredient(context: Constants.context)
        ingredient06.name = "Salt"
        ingredient06.systemGenerated = true
        let ingredient07 = Ingredient(context: Constants.context)
        ingredient07.name = "Pasta"
        ingredient07.systemGenerated = true
        let ingredient08 = Ingredient(context: Constants.context)
        ingredient08.name = "Tomato"
        ingredient08.systemGenerated = true
        let ingredient09 = Ingredient(context: Constants.context)
        ingredient09.name = "Onion"
        ingredient09.systemGenerated = true
        let ingredient10 = Ingredient(context: Constants.context)
        ingredient10.name = "Cheese, American"
        ingredient10.systemGenerated = true
        
        let ingredient11 = Ingredient(context: Constants.context)
        ingredient11.name = "Cheese, Swiss"
        ingredient11.systemGenerated = true
        let ingredient12 = Ingredient(context: Constants.context)
        ingredient12.name = "Cheese, Provolone"
        ingredient12.systemGenerated = true
        let ingredient13 = Ingredient(context: Constants.context)
        ingredient13.name = "Cheese, Cheddar"
        ingredient13.systemGenerated = true
        let ingredient14 = Ingredient(context: Constants.context)
        ingredient14.name = "Spinach"
        ingredient14.systemGenerated = true
        let ingredient15 = Ingredient(context: Constants.context)
        ingredient15.name = "Tofu"
        ingredient15.systemGenerated = true
        let ingredient16 = Ingredient(context: Constants.context)
        ingredient16.name = "Turkey"
        ingredient16.systemGenerated = true
        let ingredient17 = Ingredient(context: Constants.context)
        ingredient17.name = "Ham"
        ingredient17.systemGenerated = true
        let ingredient18 = Ingredient(context: Constants.context)
        ingredient18.name = "Beans, Green"
        ingredient18.systemGenerated = true
        let ingredient19 = Ingredient(context: Constants.context)
        ingredient19.name = "Brocolli"
        ingredient19.systemGenerated = true
        let ingredient20 = Ingredient(context: Constants.context)
        ingredient20.name = "Beans, Black"
        ingredient20.systemGenerated = true
        
        let ingredient21 = Ingredient(context: Constants.context)
        ingredient21.name = "Sausage, Pork"
        ingredient21.systemGenerated = true
        let ingredient22 = Ingredient(context: Constants.context)
        ingredient22.name = "Sausage, Italian"
        ingredient22.systemGenerated = true
        let ingredient23 = Ingredient(context: Constants.context)
        ingredient23.name = "Oregano"
        ingredient23.systemGenerated = true
        let ingredient24 = Ingredient(context: Constants.context)
        ingredient24.name = "Peppers, Green"
        ingredient24.systemGenerated = true
        let ingredient25 = Ingredient(context: Constants.context)
        ingredient25.name = "Beans, Kidney"
        ingredient25.systemGenerated = true
        let ingredient26 = Ingredient(context: Constants.context)
        ingredient26.name = "Pickles, Dill"
        ingredient26.systemGenerated = true
        let ingredient27 = Ingredient(context: Constants.context)
        ingredient27.name = "Tomato Sauce"
        ingredient27.systemGenerated = true
        let ingredient28 = Ingredient(context: Constants.context)
        ingredient28.name = "Olives, Black"
        ingredient28.systemGenerated = true
        let ingredient29 = Ingredient(context: Constants.context)
        ingredient29.name = "Chilli Powder"
        ingredient29.systemGenerated = true
        let ingredient30 = Ingredient(context: Constants.context)
        ingredient30.name = "Mushroom"
        ingredient30.systemGenerated = true
        
        let ingredient31 = Ingredient(context: Constants.context)
        ingredient31.name = "Vanilla Extract"
        ingredient31.systemGenerated = true
        let ingredient32 = Ingredient(context: Constants.context)
        ingredient32.name = "Flour"
        ingredient32.systemGenerated = true
        let ingredient33 = Ingredient(context: Constants.context)
        ingredient33.name = "Sugar, White"
        ingredient33.systemGenerated = true
        let ingredient34 = Ingredient(context: Constants.context)
        ingredient34.name = "Sugar, Brown"
        ingredient34.systemGenerated = true
        let ingredient35 = Ingredient(context: Constants.context)
        ingredient35.name = "Baking Soda"
        ingredient35.systemGenerated = true
        let ingredient36 = Ingredient(context: Constants.context)
        ingredient36.name = "Lamb"
        ingredient36.systemGenerated = true
        let ingredient37 = Ingredient(context: Constants.context)
        ingredient37.name = "Veal"
        ingredient37.systemGenerated = true
        let ingredient38 = Ingredient(context: Constants.context)
        ingredient38.name = "Shrimp"
        ingredient38.systemGenerated = true
        let ingredient39 = Ingredient(context: Constants.context)
        ingredient39.name = "Seabass"
        ingredient39.systemGenerated = true
        let ingredient40 = Ingredient(context: Constants.context)
        ingredient40.name = "Flounder"
        ingredient40.systemGenerated = true
        
        let ingredient41 = Ingredient(context: Constants.context)
        ingredient41.name = "Swordfish"
        ingredient41.systemGenerated = true
        let ingredient42 = Ingredient(context: Constants.context)
        ingredient42.name = "Salmon"
        ingredient42.systemGenerated = true
        let ingredient43 = Ingredient(context: Constants.context)
        ingredient43.name = "Rice, White"
        ingredient43.systemGenerated = true
        let ingredient44 = Ingredient(context: Constants.context)
        ingredient44.name = "Rice, Brown"
        ingredient44.systemGenerated = true
        let ingredient45 = Ingredient(context: Constants.context)
        ingredient45.name = "Salsa, Mild"
        ingredient45.systemGenerated = true
        let ingredient46 = Ingredient(context: Constants.context)
        ingredient46.name = "Salsa, Medium"
        ingredient46.systemGenerated = true
        let ingredient47 = Ingredient(context: Constants.context)
        ingredient47.name = "Salsa, Hot"
        ingredient47.systemGenerated = true
        let ingredient48 = Ingredient(context: Constants.context)
        ingredient48.name = "Cream, Sour"
        ingredient48.systemGenerated = true
        let ingredient49 = Ingredient(context: Constants.context)
        ingredient49.name = "Lemon"
        ingredient49.systemGenerated = true
        let ingredient50 = Ingredient(context: Constants.context)
        ingredient50.name = "Milk, Whole"
        ingredient50.systemGenerated = true
        
        Constants.ad.saveContext()
    }
    
    func attemptCategoryTypeFetch() {
        let fetchRequest: NSFetchRequest<CategoryType> = CategoryType.fetchRequest()
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: Constants.context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)

        self.categoryTypeController = controller
        
        do {
            try controller.performFetch()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func attemptIngredientFetch() {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: Constants.context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)

        self.ingredientController = controller
        
        do {
            try controller.performFetch()
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func attemptRecipeFetch() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: Constants.context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        self.recipeController = controller
        
        do {
            try controller.performFetch()
        } catch let err {
            print(err.localizedDescription)
        }
    }
}
