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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(RecipleaseTableViewCell.nib(), forCellReuseIdentifier: RecipleaseTableViewCell.identifier)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecipleaseListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipleaseTableViewCell.identifier, for: indexPath) as! RecipleaseTableViewCell

        let recipe = recipes[indexPath.row]

        // Mettez à jour la cellule avec les données de la recette
        cell.recipleaseNameLabel.text = recipe.label

        // Assurez-vous que votre modèle de données Recipe contient une propriété image
        // pour afficher l'image de la recette dans la cellule (exemple : recipe.image)

        return cell
    }
}


