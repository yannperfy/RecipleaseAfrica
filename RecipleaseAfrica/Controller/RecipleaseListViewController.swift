//
//  RecipleaseListViewController.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 20/08/2023.
//

import UIKit

class RecipleaseListViewController: UIViewController {
    static var cellIdentifier = "RecipeCell"
    
    

    @IBOutlet weak var listTableView: UITableView!
    
    var recipes: [Recipe] = []
    var loadRecipesClosure: (() -> Void)?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("RecipleaseListViewController est affichée.")
        listTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(RecipleaseTableViewCell.nib(), forCellReuseIdentifier: RecipleaseTableViewCell.identifier)

        // Chargez les recettes ici
        loadRecipes()
        print("loadRecipes() appelée")
    }


    func loadRecipes() {
        print("Chargement des recettes en cours...") // Ajoutez cette ligne pour vérifier si la méthode est appelée
        // Appelez la méthode getRecipes de PresentService pour obtenir les recettes
        PresentService.getRecipes(keyword: "votre_mot_clé") { [weak self] (recipes, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Erreur lors de la récupération des recettes : \(error)")
                    // Gérez l'erreur, par exemple, affichez un message à l'utilisateur
                } else if let recipes = recipes {
                    // Les recettes ont été chargées avec succès
                    self?.recipes = recipes

                    // Après avoir chargé les données dans recipes, vérifiez s'il y a des données avant de recharger la table
                    if recipes.isEmpty {
                        // Aucune donnée à afficher, vous pouvez gérer cela en affichant un message par exemple
                        print("Aucune recette à afficher.")
                    } else {
                        // Il y a des données à afficher, rechargez la table
                        self?.listTableView.reloadData()
                        print("Recettes chargées avec succès.") // Ajoutez cette ligne pour vérifier si les recettes sont chargées
                    }
                }
                // Appeler la closure pour signaler que les données ont été chargées
                self?.loadRecipesClosure?()
            }
        }
    }


  

}

extension RecipleaseListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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


