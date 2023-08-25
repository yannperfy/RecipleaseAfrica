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
    
    
    
    
    
    @IBAction func add(_ sender: Any) {
        
        guard let recipeName = recipleaseTextField1.text, !recipeName.isEmpty else {
            return
        }

        // Utilisez recipeName pour créer une nouvelle instance de Reciplease
            let reciplease = Reciplease(ingr: recipeName)

            PresentService.shared.add(present: reciplease)
        
        tableView.reloadData()
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

