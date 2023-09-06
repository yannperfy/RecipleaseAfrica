//
//  RecipleaseListViewController.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 20/08/2023.
//

import UIKit

class RecipleaseListViewController: UIViewController {
    
    

    @IBOutlet weak var listTableView: UITableView!
    
    var recipes: [Recipe] = []
    var loadRecipesClosure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(RecipleaseTableViewCell.nib(), forCellReuseIdentifier: RecipleaseTableViewCell.identifier)
        
        
    }
   
    // Fonction pour charger des données factices (vous pouvez la remplacer par le chargement de données réelles)
    func loadRecipes() {
        // Exemple de données de recette
        let recipe1 = Recipe(
            uri: "recipe_uri",
            label: "Recette 1",
            image: "image_url1",
            images: RecipeImages(
                thumbnail: RecipeImage(url: "thumbnail_url", width: 100, height: 100),
                small: RecipeImage(url: "small_url", width: 200, height: 200),
                regular: RecipeImage(url: "regular_url", width: 400, height: 400),
                large: RecipeImage(url: "large_url", width: 800, height: 800)
            ),
            source: "source",
            url: "recipe_url",
            shareAs: "share_url",
            yield: 4,
            dietLabels: ["label1", "label2"],
            healthLabels: ["health1", "health2"],
            cautions: ["caution1", "caution2"],
            ingredientLines: ["ingredient1", "ingredient2"],
            ingredients: [
                RecipeIngredient(
                    text: "ingredient_text",
                    quantity: 1.0,
                    measure: "measure",
                    food: "food",
                    weight: 100.0,
                    foodId: "food_id"
                )
            ],
            calories: 200.0,
            glycemicIndex: 0.0,
            totalCO2Emissions: 0.0,
            co2EmissionsClass: "class",
            totalWeight: 0.0,
            cuisineType: ["cuisine1", "cuisine2"],
            mealType: ["meal1", "meal2"],
            dishType: ["dish1", "dish2"],
            instructions: ["instruction1", "instruction2"],
            tags: ["tag1", "tag2"],
            externalId: "external_id",
            totalNutrients: ["nutrient1": 100.0, "nutrient2": 200.0],
            totalDaily: ["daily1": 10.0, "daily2": 20.0],
            digest: [
                RecipeDigest(
                    label: "digest_label",
                    tag: "digest_tag",
                    schemaOrgTag: "schema_org_tag",
                    total: 100.0,
                    hasRDI: true,
                    daily: 10.0,
                    unit: "unit",
                    sub: ["sub1": 50.0, "sub2": 50.0]
                )
            ]
        )

        
        
        // Ajoutez les recettes à votre tableau recipes
        recipes.append(recipe1)
        
        
        // Après avoir chargé les données dans recipes, vérifiez s'il y a des données avant de recharger la table
        if recipes.isEmpty {
            // Aucune donnée à afficher, vous pouvez gérer cela en affichant un message par exemple
            print("Aucune recette à afficher.")
        } else {
            // Il y a des données à afficher, rechargez la table
            listTableView.reloadData()
        }
        // Appeler la closure pour signaler que les données ont été chargées
          loadRecipesClosure?()
    }

}

extension RecipleaseListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return recipes.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecipleaseTableViewCell.identifier, for: indexPath) as! RecipleaseTableViewCell

            let recipe = recipes[indexPath.row]

            // Affichez le nom de la recette
            cell.recipleaseNameLabel.text = recipe.label

            // Affichez l'image de la recette
            if let imageURL = URL(string: recipe.image), let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) {
                cell.recipleaseImageView.image = image
            } else {
                // Gérez le cas où l'image de la recette n'est pas disponible
                cell.recipleaseImageView.image = UIImage(named: "placeholder_image") // Utilisez une image de remplacement
            }

            return cell
    }
}


