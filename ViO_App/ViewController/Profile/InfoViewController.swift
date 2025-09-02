//
//  InfoViewController.swift
//  ViO_App
//
//  Created by Samet Arabacı on 1.04.2025.
//

import UIKit
import FirebaseAnalytics

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var infoSubjectView: UIView!
    @IBOutlet weak var infoPopUpView: UIView!
    @IBOutlet weak var infoPopUpLabel: UILabel!
    @IBOutlet weak var infoCloseImage: UIImageView!
    @IBOutlet weak var infoTableView: UITableView!
    
    let categories = InfoBmiCategories.categori
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoPopUpLabel.text = "Bilgilendirme Ekranı"
        
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        
        popUpUI()
        closePopUp()
        
        isModalInPresentation = true
        
        Analytics.logEvent("info_view_shown", parameters: [
            "screen": "InfoViewController"
        ])
    
    }
    
    func popUpUI(){
        
        infoPopUpView.layer.cornerRadius = 10
        infoSubjectView.layer.cornerRadius = 8
        
        infoPopUpView.backgroundColor = UIColor(named: "CustomBackgroundColor")
        infoSubjectView.backgroundColor = UIColor(named: "GenderBackgroundColor")
        
        infoTableView.backgroundColor = UIColor(named: "CustomBackgroundColor")
        infoTableView.layer.cornerRadius = 10
        
        
    }
    
    func closePopUp(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeInfo))
        infoCloseImage.isUserInteractionEnabled = true
        infoCloseImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func closeInfo() {
        Analytics.logEvent("info_view_closed", parameters: [
            "screen": "InfoViewController"
        ])
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoTableViewCell
        
        let category = categories[indexPath.row]
        
        cell.configure(with: category)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "CustomBackgroundColor")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        infoTableView.deselectRow(at: indexPath, animated: true)
    }
    
}
