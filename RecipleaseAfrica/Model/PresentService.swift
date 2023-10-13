//
//  RecipleaseService.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 23/08/2023.
//
import Foundation

class PresentService {
    static let recipleaseUrl = URL(string: "https://api.edamam.com/api/recipes/v2")!
    static let shared = PresentService()
    private init() {}

    private static var dataTask: URLSessionDataTask?
    
    static func getRecipes(keyword: String, callback: @escaping ([Reciplease]?, Error?) -> Void) {
        let keywords = keyword.split { !$0.isLetter }

        guard keywords.count != 1 else {
            getImage(keyword: keyword) { (success, recipe) in
                if success, let recipe = recipe {
                    callback([recipe], nil)
                } else {
                    // Créez une erreur en cas d'échec
                    let error = NSError(domain: "YourErrorDomain", code: 1, userInfo: nil)
                    callback(nil, error)
                }
            }
            return
        }

        let requestBody: [String: Any] = [
            "type": "public",
            "app_key": "33f90e6e97ed8715c1c0efb964c37524",
            "app_id": "6632c2fb",
            "q": "",
            "Accept-Language": "en",
            "beta": true,
            "ingr": "1-2",
            "imageSize": "REGULAR"
            // Ajoutez d'autres paramètres si nécessaire
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            let error = NSError(domain: "YourErrorDomain", code: 3, userInfo: nil)
            callback(nil, error)
            return
        }

        var request = URLRequest(url: recipleaseUrl)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        PresentService.cancelDataTask()

        let session = URLSession(configuration: .default)

        dataTask = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Erreur lors de la requête : \(error!)")
                // Renvoyez l'erreur avec le code de statut HTTP de la réponse
                let httpResponse = response as? HTTPURLResponse
                let statusCode = httpResponse?.statusCode ?? 500
                let customError = NSError(domain: "YourErrorDomain", code: statusCode, userInfo: nil)
                callback(nil, customError)
                return
            }

            guard let data = data else {
                print("Aucune donnée reçue")
                // Créez une erreur en cas d'absence de données
                let error = NSError(domain: "YourErrorDomain", code: 2, userInfo: nil)
                callback(nil, error)
                return
            }
        


            do {
                // Affichez la réponse JSON brute dans la console
                let jsonString = String(data: data, encoding: .utf8) ?? "Response data is not a valid UTF-8 string"
                print("Raw JSON response:\n\(jsonString)")
                
                let decoder = JSONDecoder()
                let response = try decoder.decode(RecipeResponse.self, from: data)
                // Le reste de votre code pour décoder la réponse...
                
                // Extrait les recettes du tableau "hits" de la réponse
                let recipes = response.hits.map { $0.recipe }
                // Renvoyez les données de recette
                let recipleaseRecipes = recipes.map { recipe in
                    return Reciplease(ingr: recipe.label, uri: recipe.uri, label: recipe.label, image: recipe.image, images: recipe.images, source: recipe.source, url: recipe.url, shareAs: recipe.shareAs, yield: recipe.yield, dietLabels: recipe.dietLabels, healthLabels: recipe.healthLabels, cautions: recipe.cautions, ingredientLines: recipe.ingredientLines, ingredients: recipe.ingredients, calories: recipe.calories, glycemicIndex: recipe.glycemicIndex, totalCO2Emissions: recipe.totalCO2Emissions, co2EmissionsClass: recipe.co2EmissionsClass, totalWeight: recipe.totalWeight, cuisineType: recipe.cuisineType, mealType: recipe.mealType, dishType: recipe.dishType, instructions: recipe.instructions, tags: recipe.tags, externalId: recipe.externalId, totalNutrients: recipe.totalNutrients, totalDaily: recipe.totalDaily, digest: recipe.digest)
                }
                callback(recipleaseRecipes, nil)
            } catch {
                print("Erreur lors du décodage JSON : \(error)")
                // Renvoyez l'erreur de décodage
                callback(nil, error)
            }

        }

        dataTask?.resume()
    }


    static func getImage(keyword: String, callback: @escaping (Bool, Reciplease?) -> Void) {
        // Implémentez la logique pour obtenir une image avec le mot clé ici
        // ...
    }

    static func cancelDataTask() {
        dataTask?.cancel()
    }

    private(set) var presents: [Present] = []

    func add(present: Present) {
        presents.append(present)
    }

    func remove(at index: Int) {
        presents.remove(at: index)
    }
}

