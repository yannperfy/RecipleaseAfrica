//
//  Reciplease.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 23/08/2023.
//

import Foundation

struct Reciplease {
 
    let ingr: String
    let images: RecipeImages
}
struct RecipeResponse: Codable {
    let from: Int
    let to: Int
    let count: Int
    let links: Links?// Assurez-vous que la clé "links" est définie ici
    let hits: [RecipeHit]
}



struct Links: Codable {
    let selfLink: Link?
    let next: Link?
}

struct Link: Codable {
    let href: String
    let title: String
}

struct RecipeHit: Codable {
    let recipe: Recipe
    let links: Links?
}

struct Recipe: Codable {
    let uri: String
    let label: String
    let image: String
    let images: RecipeImages
    let source: String
    let url: String
    let shareAs: String
    let yield: Int
    let dietLabels: [String]
    let healthLabels: [String]
    let cautions: [String]
    let ingredientLines: [String]
    let ingredients: [RecipeIngredient]
    let calories: Double
    let glycemicIndex: Double
    let totalCO2Emissions: Double
    let co2EmissionsClass: String
    let totalWeight: Double
    let cuisineType: [String]
    let mealType: [String]
    let dishType: [String]
    let instructions: [String]
    let tags: [String]
    let externalId: String
    let totalNutrients: [String: Double]
    let totalDaily: [String: Double]
    let digest: [RecipeDigest]
}

struct RecipeImages: Codable {
    let thumbnail: RecipeImage
    let small: RecipeImage
    let regular: RecipeImage
    let large: RecipeImage
}

struct RecipeImage: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct RecipeIngredient: Codable {
    let text: String
    let quantity: Double
    let measure: String
    let food: String
    let weight: Double
    let foodId: String
}

struct RecipeDigest: Codable {
    let label: String
    let tag: String
    let schemaOrgTag: String
    let total: Double
    let hasRDI: Bool
    let daily: Double
    let unit: String
    let sub: [String: Double]
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


