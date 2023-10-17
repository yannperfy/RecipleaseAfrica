//
//  ViewController.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 18/08/2023.
//

import UIKit

class RecipleaseViewController: UIViewController {
    @IBOutlet weak var recipleaseTextField: UITextField!

    @IBOutlet weak var addRecipeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchRecipeButton: UIButton!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
           super.viewDidLoad()
        configureUI()
       }

    private func configureUI() {
           // Configurez l'apparence des boutons
           addRecipeButton.layer.cornerRadius = 20
           searchRecipeButton.layer.cornerRadius = 20

           // Configurez la table view
           tableView.dataSource = self
           tableView.delegate = self
           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PresentCell")

           // Cachez l'indicateur d'activité au départ
           activityIndicator.isHidden = true
       }
    // Méthode pour masquer le clavier
    @IBAction func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        recipleaseTextField.resignFirstResponder()

    }
    
    
    @IBAction func addRecipe(_ sender: Any) {

        guard let recipeName = recipleaseTextField.text, !recipeName.isEmpty else {
               return
           }

           // Utilisez recipeName pour créer une nouvelle instance de Reciplease
           let images = Images(thumbnail: Large(url: "thumbnail_url", width: 100, height: 100), small: Large(url: "small_url", width: 200, height: 200), regular: Large(url: "regular_url", width: 400, height: 400), large: Large(url: "large_url", width: 800, height: 800))

        let reciplease = Recipe(uri: "",
                                label: recipeName,
                                image: "",
                                images: images,
                                source: "",
                                url: "",
                                shareAs: "",
                                yield: 0,
                                dietLabels: [],
                                healthLabels: [],
                                cautions: [],
                                ingredientLines: [],
                                ingredients: [],
                                calories: 0.0,
                                totalCO2Emissions: 0.0,
                                co2EmissionsClass: "",
                                totalWeight: 0.0,
                                totalTime: 0,
                                cuisineType: [],
                                mealType: [],
                                dishType: [],
                                totalNutrients: [:],
                                totalDaily: [:],
                                digest: [])

        PresentService.shared.add(present: reciplease)
        tableView.reloadData()
    }
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        searchRecipeButton.isHidden = shown
    }
//
    @IBAction func searchRecipe(_ sender: Any) {
        print("recipeSeach button tapped")
        guard let keyword = recipleaseTextField.text, !keyword.isEmpty else {
                return
            }
        PresentService.getRecipes(keyword: keyword) { (recipes, error) in
               // Gérez la réponse et les erreurs ici
               DispatchQueue.main.async {
                   if let recipes = recipes {
                       // Traitez les recettes reçues
                       print(recipes)
                   } else if let error = error {
                       // Traitez les erreurs ici (par exemple, affichez-les dans la console)
                       print("Error: \(error)")
                       // Affichez l'alerte de présentation en cas d'erreur

                       self.presentAlert()
                   }
               }
           }

    }
    
    
      func presentAlert() {
          
          print("presentAlert() called")
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Error", message: "Could not find a recipe.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
  

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        

    }
    
  
  


}

extension RecipleaseViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PresentService.shared.presents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: "PresentCell", for: indexPath) as? PresentTableViewCell else {
            return UITableViewCell()
        }

        let present = PresentService.shared.presents[indexPath.row]
        
     

        // Accédez à la propriété "ingr" de Reciplease et affichez-la dans la cellule
        cell.textLabel?.text = present.description

        return cell
        
    }




}


extension RecipleaseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PresentService.shared.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

