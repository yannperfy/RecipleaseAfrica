//
//  Reciplease.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 23/08/2023.
//

import Foundation

struct Reciplease {
 
    let ingr: String
}

extension Reciplease: Present {
    var details: String {
        return ingr
    }
    
    // Variable pour suivre le numéro actuel
    static var ingredientNumber = 1

    var description: String {
        let currentIngredientNumber = Reciplease.ingredientNumber
        Reciplease.ingredientNumber += 1 // Incrémente le numéro pour le prochain ingrédient
        return "\(currentIngredientNumber) - \(ingr)"
    }
}


