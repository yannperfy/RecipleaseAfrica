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
        if keywords.count == 1 {
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
            "app_key": "33f90e6e97ed8715c1c0efb964c37524",
            "app_id": "6632c2fb",
            // Ajoutez d'autres paramètres si nécessaire
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)

            var request = URLRequest(url: recipleaseUrl)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            PresentService.cancelDataTask()

            let session = URLSession(configuration: .default)

            dataTask = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Erreur lors de la requête : \(error)")
                    // Renvoyez l'erreur
                    callback(nil, error)
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
                    callback(recipes, nil)
                } catch {
                    print("Erreur lors du décodage JSON : \(error)")
                    // Renvoyez l'erreur de décodage
                    callback(nil, error)
                }
            }

            dataTask?.resume()
        } catch {
            print("Erreur lors de la création des données JSON : \(error)")
            // Renvoyez l'erreur de création JSON
            callback(nil, error)
        }
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
