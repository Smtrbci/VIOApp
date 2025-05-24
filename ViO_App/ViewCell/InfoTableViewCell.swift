//
//  InfoTableViewCell.swift
//  ViO_App
//
//  Created by Samet Arabacı on 1.04.2025.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var recommendationsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with category: InfoCategory) {
        categoryLabel.text = category.categories
        adviceLabel.text = category.advice
        recommendationsLabel.text = category.recommendations.joined(separator: "\n")
        
        adviceLabel.numberOfLines = 0
        adviceLabel.lineBreakMode = .byWordWrapping
        
        recommendationsLabel.numberOfLines = 0
        recommendationsLabel.lineBreakMode = .byWordWrapping
        
        cellView.backgroundColor = UIColor(named: "GenderBackgroundColor")
        cellView.layer.cornerRadius = 6
        
        }
    
}
