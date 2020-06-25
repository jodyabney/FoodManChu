//
//  Constants.swift
//  DreamLister
//
//  Created by Jody Abney on 6/8/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    static let ad = UIApplication.shared.delegate as! AppDelegate
    static let context = ad.persistentContainer.viewContext
    static let ingredientCellReuseId = "IngredientCell"
    static let recipeCellReuseId = "RecipeCell"
    
    enum Segues {
        static let addNewIngredient = "SegueAddNewIngredient"
        static let editIngredient = "SegueEditItem"
        static let addNewRecipe = "SegueAddNewRcipe"
        static let editRecipe = "SegueEditRecipe"
        static let chooseIngredients = "SegueChooseIngredients"
        static let viewRecipe = "SegueViewRecipe"
        static let editRecipeFromView = "SegueEditRecipeFromView"
    }
    
    
}
