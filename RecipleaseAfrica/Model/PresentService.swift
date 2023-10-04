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

    static func getRecipes(keyword: String, callback: @escaping ([Recipe]?, Error?) -> Void) {
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
            "q": "reciplease",
            "Accept-Language": "en"
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
                print("Erreur lor   s de la requête : \(error!)")
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
                let decoder = JSONDecoder()
                let recipes = try decoder.decode([Recipe].self, from: data)
                // Renvoyez les données de recette
                callback(recipes, nil)
            } catch {
                print("Erreur lors du décodage JSON : \(error)")
                // Renvoyez l'erreur de décodage
                callback(nil, error)
            }
        }

        dataTask?.resume()
    }

    static func getImage(keyword: String, callback: @escaping (Bool, Recipe?) -> Void) {
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
