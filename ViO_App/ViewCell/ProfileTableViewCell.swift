//
//  ProfileTableViewCell.swift
//  ViO_App
//
//  Created by Samet Arabacı on 22.03.2025.
//

import UIKit

protocol ProfileTableViewCellDelegate: AnyObject {
    func didTapDeleteButton(in cell: ProfileTableViewCell)
}

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bmiValueLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var bmiCellView: UIView!
    
    @IBOutlet weak var deleteImage: UIImageView!
    
    weak var delegate: ProfileTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteImageTapped))
        deleteImage.isUserInteractionEnabled = true
        deleteImage.addGestureRecognizer(tapGesture)
        
    }
    
    func initUI(){

        bmiCellView.backgroundColor = UIColor(named: "GenderBackgroundColor")
        backgroundColor = UIColor.clear
        bmiCellView.layer.shadowOpacity = 0.5
        bmiCellView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bmiCellView.layer.shadowRadius = 3
        bmiCellView.layer.cornerRadius = 6
        bmiCellView.layer.masksToBounds = false
        bmiCellView.layer.shadowColor = UIColor(named: "CellGenderBackgroundColor")?.cgColor
    }
    
    @objc func deleteImageTapped() {
            delegate?.didTapDeleteButton(in: self)
        }
    
    
    
    
        
}
