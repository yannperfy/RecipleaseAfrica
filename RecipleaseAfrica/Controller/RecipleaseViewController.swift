//
//  ViewController.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 18/08/2023.
//

import UIKit

class RecipleaseViewController: UIViewController {
    @IBOutlet weak var recipleaseTextField1: UITextField!
    
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var recipeSeach: UIButton!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func add(_ sender: Any) {
        
        guard let recipeName = recipleaseTextField1.text, !recipeName.isEmpty else {
               return
           }

           // Utilisez recipeName pour créer une nouvelle instance de Reciplease
           let images = RecipeImages(thumbnail: RecipeImage(url: "thumbnail_url", width: 100, height: 100), small: RecipeImage(url: "small_url", width: 200, height: 200), regular: RecipeImage(url: "regular_url", width: 400, height: 400), large: RecipeImage(url: "large_url", width: 800, height: 800))

           let reciplease = Reciplease(ingr: recipeName, images: images)

           PresentService.shared.add(present: reciplease)

           tableView.reloadData()
    }
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        recipeSeach.isHidden = shown
    }
    
    @IBAction func recipeSeach(_ sender: Any) {
        
        guard let searchQuery = recipleaseTextField1.text, !searchQuery.isEmpty else {
                return
            }

            PresentService.shared.getRecipe(searchQuery: searchQuery) { (response, error) in
                // Gérez la réponse et les erreurs ici
                if let response = response {
                    // Traitez la réponse JSON ici (par exemple, affichez-la dans la console)
                    print(response)
                } else if let error = error {
                    // Traitez les erreurs ici (par exemple, affichez-les dans la console)
                    print("Error: \(error)")
                    // Affichez l'alerte de présentation en cas d'erreur
                    self.presentAlert()
                }
            }
    }
    
    
    
    private func presentAlert() {
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
    
    static var cellIdentifier = "PresentCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

