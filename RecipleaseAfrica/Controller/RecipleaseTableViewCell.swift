//
//  RecipleaseTableViewCell.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 20/08/2023.
//

import UIKit

class RecipleaseTableViewCell: UITableViewCell {
    @IBOutlet weak var recipleaseImageView: UIImageView!
    
    @IBOutlet weak var recipleaseNameLabel: UILabel!
    
    @IBOutlet weak var recipleaseIngredientsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    static let identifier = "RecipleaseTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName:"RecipleaseTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        recipleaseImageView.layer.cornerRadius = 20
        recipleaseNameLabel.layer.cornerRadius = 10
        recipleaseIngredientsLabel.layer.cornerRadius = 10
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
