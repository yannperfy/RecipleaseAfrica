//
//  RecipleaseListViewController.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 20/08/2023.
//

import UIKit

class RecipleaseListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    
    var  strings: [String] = ["Ndolet", "Plantain", "Frites"]
    var imageFoods: [String] = ["frites", "Alloco", "Ndolet"]
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ingredientsVC")
        
        vc.navigationItem.title = strings[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipleaseTableViewCell.identifier, for: indexPath) as! RecipleaseTableViewCell

        if let image = UIImage(named: imageFoods[indexPath.row]) {
            cell.recipleaseImageView.image = image
        } else {
            cell.recipleaseImageView.image = UIImage(systemName: "photo") // Image par défaut en cas de problème de chargement
        }

        cell.recipleaseImageView.contentMode = .scaleAspectFill // Assurez-vous que l'image remplit la cellule
        cell.recipleaseNameLabel.text = strings[indexPath.row]

        return cell
    }


    
}
