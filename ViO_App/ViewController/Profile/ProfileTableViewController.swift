//
//  ProfileTableViewController.swift
//  ViO_App
//
//  Created by Samet Arabacı on 22.03.2025.
//

import UIKit
import CoreData
import FirebaseCrashlytics
import FirebaseAnalytics

class ProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileTableViewCellDelegate  {
    
    @IBOutlet weak var profileMenuView: UIView!
    @IBOutlet var profileView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var bmiInfoView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileInfoImage: UIImageView!
    @IBOutlet weak var infoCategoryLabel: UILabel!
    @IBOutlet weak var infoBmiLabal: UILabel!
    
    var bmiResults: [[String: Any]] = []
    
        override func viewDidLoad() {
            super.viewDidLoad()
            Analytics.logEvent("profile_view_shown", parameters: [
                "screen": "ProfileTableViewController"
            ])
            loadBmiData()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
            
            initUI()
            infoView()
            infoTappedImage()
        }
    
    private func initUI(){
        profileLabel.text = "Profiliniz"
        infoBmiLabal.text = "BMI"
        infoCategoryLabel.text = "Kategori"
        bmiInfoView.backgroundColor = UIColor(named: "CustomBackgroundColor")
        profileMenuView.backgroundColor = UIColor(named: "CustomBackgroundColor")
        tableView.backgroundColor = UIColor(named: "CustomBackgroundColor")
        profileView.backgroundColor = UIColor(named: "CustomBackgroundColor")
        tableView.separatorStyle = .none
    }
    
    func infoView(){
        bmiInfoView.layer.cornerRadius = 10
        bmiInfoView.layer.borderWidth = 1
        bmiInfoView.layer.borderColor = UIColor(named: "CellBackgroundColor")?.cgColor
    }
    
    func infoTappedImage(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(infoTapped))
        profileInfoImage.isUserInteractionEnabled = true
        profileInfoImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func infoTapped(){
        showCustomInfoPopUp()
    }
    
    func showCustomInfoPopUp(){
        Crashlytics.crashlytics().log("InfoViewController basıldı")
        Analytics.logEvent("info_popup_triggered", parameters: [
            "source": "ProfileTableViewController"
        ])
        let storyboard = UIStoryboard(name: "InfoPopUp", bundle: nil)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController {
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve
            present(popupVC, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            loadBmiData()
            tableView.reloadData()
        }
        
        func loadBmiData() {
            if let savedResults = UserDefaults.standard.array(forKey: "BMIResults") as? [[String: Any]] {
                    bmiResults = savedResults
                    print("Kaydedilen BMI Verileri: \(bmiResults)")
                } else {
                    print("Veriler bulunamadı.")
                }
        }
    
         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return bmiResults.count
        }
        
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             
             let cell = tableView.dequeueReusableCell(withIdentifier: "BMICell", for: indexPath) as! ProfileTableViewCell
                 
                 let bmiResult = bmiResults[indexPath.row]
        
                 if let bmiValue = bmiResult["bmi"] as? Double, let category = bmiResult["category"] as? String {
                     cell.bmiValueLabel.text = "\(String(format: "%.1f", bmiValue))"
                     cell.categoryLabel.text = category
                     cell.selectionStyle = .none
                     cell.delegate = self
                     print("Hücre verisi: BMI: \(bmiValue), Kategori: \(category)")
                 }
                 return cell
             }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    func didTapDeleteButton(in cell: ProfileTableViewCell) {
            guard let indexPath = tableView.indexPath(for: cell) else { return }
        let bmiToDelete = bmiResults[indexPath.row]["bmi"] as? Double ?? 0.0
            BmiDataManager.clearBmiResults(for: bmiToDelete)
            bmiResults.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
