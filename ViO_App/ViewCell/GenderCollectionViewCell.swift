//
//  GenderCollectionViewCell.swift
//  ViO_App
//
//  Created by Samet Arabacı on 21.02.2025.
//

import UIKit

class GenderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genderImageView: UIImageView!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with gender: GenderModel){
        genderImageView.image = gender.image
        genderLabel.text = gender.title
    }
    
}
