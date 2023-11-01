import Foundation
import UIKit

struct RecipeRequestData: Codable {
    let type: String
    let app_key: String
    let app_id: String
    let q: String
    let beta: Bool
    let ingr: String
    let imageSize: String
    // Ajoutez d'autres propriétés au besoin
}

enum PresentServiceError: Error {
    case httpResponseError(statusCode: Int)
    case decodingError(underlyingError: Error)
    case missingData
    case unauthorized
    case networkError(underlyingError: Error)
    case unknownError
    // Ajoutez d'autres cas d'erreur au besoin
}

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
                    let error = PresentServiceError.unauthorized
                    callback(nil, error)
                }
            }
            return
        }

        // Utilisation d'une requête GET
        var components = URLComponents(url: recipleaseUrl, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "app_key", value: "ef9b72abe604309867831ef54089f3d3"),
            URLQueryItem(name: "app_id", value: "6632c2fb"),
            URLQueryItem(name: "q", value: "pizza"),
            URLQueryItem(name: "beta", value: "true"),
            URLQueryItem(name: "ingr", value: "3-8"),
            URLQueryItem(name: "imageSize", value: "REGULAR")
        ]

        guard let requestUrl = components?.url else {
            let error = PresentServiceError.unknownError
            callback(nil, error)
            return
        }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"

        PresentService.cancelDataTask()

        let session = URLSession(configuration: .default)

        dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let networkError = PresentServiceError.networkError(underlyingError: error)
                callback(nil, networkError)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let welcome = try decoder.decode(Welcome.self, from: data)
                            // Vérifiez que la clé "hits" existe dans la réponse
                            if !welcome.hits.isEmpty {
                                let recipleaseRecipes = welcome.hits.map { $0.recipe }
                                callback(recipleaseRecipes, nil)
                            } else {
                                // Gérez le cas où il n'y a pas de recettes
                                let error = PresentServiceError.missingData
                                callback(nil, error)
                            }
                        } catch let decodingError {
                            print("Decoding Error: \(decodingError)")
                            let error = PresentServiceError.decodingError(underlyingError: decodingError)
                            callback(nil, error)
                        }
                    } else {
                        let error = PresentServiceError.missingData
                        callback(nil, error)
                    }
                case 401:
                    let error = PresentServiceError.unauthorized
                    callback(nil, error)
                default:
                    let error = PresentServiceError.httpResponseError(statusCode: httpResponse.statusCode)
                    callback(nil, error)
                }
            } else {
                let error = PresentServiceError.unknownError
                callback(nil, error)
            }
        }
        dataTask?.resume()
    }

    static func getImage(keyword: String, callback: @escaping (Bool, Recipe?) -> Void) {
        guard let imageUrl = URL(string: "https://api.edamam.com/api/recipes/v2") else {
            callback(false, nil)
            return
        }

        let session = URLSession.shared
        let imageRequest = URLRequest(url: imageUrl)

        session.dataTask(with: imageRequest) { (data, _, error) in
            if let error = error {
                let networkError = PresentServiceError.networkError(underlyingError: error)
                callback(false, nil)
                return
            }

            if let data = data {
                // Créez votre objet Recipe et appelez le callback
                do {
                    let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                    callback(true, recipe)
                } catch let decodingError {
                    print("Decoding Error: \(decodingError)")
                    callback(false, nil)
                }
            } else {
                callback(false, nil)
            }
        }.resume()
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
