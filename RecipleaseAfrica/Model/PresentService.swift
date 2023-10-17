import Foundation

// Définissez la structure RecipeRequestData pour la requête JSON
struct RecipeRequestData: Codable {
    let type: String
    let app_key: String
    let app_id: String
    let q: String
    let beta: Bool
    let ingr: String
    let imageSize: String
    // Ajoutez d'autres propriétés si nécessaire
}

enum PresentServiceError: Error {
    case unauthorized
    case missingData
    case decodingError
    // Ajoutez d'autres cas d'erreur si nécessaire
}

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
                    let error = PresentServiceError.unauthorized
                    callback(nil, error)
                }
            }
            return
        }

        // Utilisez la structure RecipeRequestData pour construire votre requête JSON
        let requestData = RecipeRequestData(
            type: "public",
            app_key: "33f90e6e97ed8715c1c0efb964c37524",
            app_id: "6632c2fb",
            q: keyword,
            beta: true,
            ingr: keyword, // Utilisation du mot-clé pour ingr
            imageSize: "REGULAR"
            // Ajoutez d'autres paramètres si nécessaire
        )

        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(requestData)

            var request = URLRequest(url: recipleaseUrl)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            PresentService.cancelDataTask()

            let session = URLSession(configuration: .default)

            dataTask = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    // Renvoyez l'erreur avec le code de statut HTTP de la réponse
                    let httpResponse = response as? HTTPURLResponse
                    let statusCode = httpResponse?.statusCode ?? 500
                    let customError = PresentServiceError.unauthorized
                    callback(nil, customError)
                    return
                }

                guard let data = data else {
                    // Créez une erreur en cas d'absence de données
                    let error = PresentServiceError.missingData
                    callback(nil, error)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let welcome = try decoder.decode(Welcome.self, from: data)
                    let recipes = welcome.hits.map { $0.recipe }

                    // Convertissez les données en instances de la structure Recipe
                    let recipleaseRecipes = recipes.map { recipe in
                        return Recipe(
                            uri: recipe.uri,
                            label: recipe.label,
                            image: recipe.image,
                            images: recipe.images,
                            source: recipe.source,
                            url: recipe.url,
                            shareAs: recipe.shareAs,
                            yield: recipe.yield,
                            dietLabels: recipe.dietLabels,
                            healthLabels: recipe.healthLabels,
                            cautions: recipe.cautions,
                            ingredientLines: recipe.ingredientLines,
                            ingredients: recipe.ingredients,
                            calories: recipe.calories,
                            totalCO2Emissions: recipe.totalCO2Emissions,
                            co2EmissionsClass: recipe.co2EmissionsClass,
                            totalWeight: recipe.totalWeight,
                            totalTime: recipe.totalTime ?? 0, // Ajoutez une valeur par défaut pour totalTime
                            cuisineType: recipe.cuisineType,
                            mealType: recipe.mealType,
                            dishType: recipe.dishType,
                            totalNutrients: recipe.totalNutrients,
                            totalDaily: recipe.totalDaily,
                            digest: recipe.digest
                        )
                    }
                    callback(recipleaseRecipes, nil)
                } catch {
                    callback(nil, PresentServiceError.decodingError)
                }
            }
            dataTask?.resume()
        } catch {
            callback(nil, PresentServiceError.missingData)
        }
    }

    static func getImage(keyword: String, callback: @escaping (Bool, Recipe?) -> Void) {
        // Implémentez la logique pour obtenir une image avec le mot-clé ici
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
