//
//  Ingredient+CoreDataClass.swift
//  FoodManChu
//
//  Created by Jody Abney on 6/10/20.
//  Copyright © 2020 AbneyAnalytics. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Ingredient)
public class Ingredient: NSManagedObject {

}

extension Ingredient: Comparable {
    public static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name! < rhs.name!
    }
}
