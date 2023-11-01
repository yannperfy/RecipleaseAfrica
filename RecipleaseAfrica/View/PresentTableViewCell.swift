//
//  PresentTableViewCell.swift
//  RecipleaseAfrica
//
//  Created by Yann Perfy on 25/08/2023.
//

import UIKit

class PresentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        addShadow()
    }
    
    
    private func addShadow() {
      
        greenView.layer.shadowRadius = 6.0
        greenView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        greenView.layer.shadowOpacity = 2.0
    }

    
}
