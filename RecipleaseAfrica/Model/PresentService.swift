//
//  RecipleaseService.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 23/08/2023.
//

import Foundation

class PresentService {
    
    private static let recipleaseUrl = URL(string: "https://api.edamam.com/api/recipes/v2")!
    
    static let shared = PresentService()
    
    private init() {}
    
    func getRecipe(searchQuery: String, completion: @escaping ([Recipe]?, Error?) -> Void) {
        // Construisez l'URL avec les paramètres de recherche appropriés
        var components = URLComponents(url: PresentService.recipleaseUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "app_key", value: "33f90e6e97ed8715c1c0efb964c37524"),
            URLQueryItem(name: "app_id", value: "6632c2fb"),
            URLQueryItem(name: "q", value: searchQuery), // Utilisez ici la recherche entrée par l'utilisateur
            URLQueryItem(name: "to", value: "8"), // Limitez le nombre de résultats si nécessaire
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "Accept-Language", value: "en")
        ]
        
        guard let url = components?.url else {
            completion(nil, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error) // Appel du gestionnaire de complétion en cas d'erreur
                return
            }
            
            if let data = data {
                // Vous devez maintenant décoder les données JSON pour obtenir les recettes
                do {
                    let recipesResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                    let recipes = recipesResponse.hits.map { $0.recipe }
                    completion(recipes, nil)
                } catch let decodingError {
                    print("Decoding error: \(decodingError)")
                    completion(nil, decodingError)
                }

            } else {
                completion(nil, nil)
            }
        }
        task.resume()
    }

    private(set) var presents: [Present] = []
    
    func add(present: Present) {
        presents.append(present)
    }
    
    func remove(at index: Int) {
        presents.remove(at: index)
    }
}
