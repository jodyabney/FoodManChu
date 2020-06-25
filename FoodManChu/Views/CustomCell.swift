//
//  SearchCell.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/10/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    func configureCell(_ ingredient: Ingredient) {
        name.text = ingredient.name
    }
    
    func configureCell(_ recipe: Recipe) {
        name.text = recipe.name
    }
    
    func configureCell(_ categoryType: CategoryType) {
        name.text = categoryType.name
    }

}
