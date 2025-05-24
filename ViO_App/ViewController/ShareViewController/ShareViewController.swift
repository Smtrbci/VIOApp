//
//  ShareViewController.swift
//  ViO_App
//
//  Created by Samet Arabacı on 3.04.2025.
//

import UIKit

class ShareViewController: UIViewController {

    @IBOutlet weak var sharesubjectLabel: UILabel!
    @IBOutlet weak var sharebmiLabel: UILabel!
    @IBOutlet weak var bmiImage: UIImageView!
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var textLabel: UILabel!
    var bmiValue: Double?
    var descriptionText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        updateUI()
        UIText()
    }

    func initUI() {
        shareView.layer.cornerRadius = 10
        shareView.layer.masksToBounds = true
        shareView.backgroundColor = UIColor(hex: "#f5f5de")
    }
    
    func UIText(){
        textLabel.text = "Sen de hesaplamak ister misin? 📲"
        textLabel.numberOfLines = 0
        sharesubjectLabel.numberOfLines = 0
        sharebmiLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        sharesubjectLabel.lineBreakMode = .byWordWrapping
        sharebmiLabel.lineBreakMode = .byWordWrapping
    }

    
    func setShareContent(bmi: Double, description: String) {
        sharebmiLabel.text = String(format: "Benim BMI sonucum: %.2f kg/m² 📊", bmi)
        sharesubjectLabel.text = description
    }
    
    func updateUI() {
            if let bmi = bmiValue {
                sharebmiLabel.text = String(format: "Benim BMI sonucum: %.2f kg/m² 📊", bmi)
            }
            if let description = descriptionText {
                sharesubjectLabel.text = description
            }
        }
    
    func convertViewToImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
