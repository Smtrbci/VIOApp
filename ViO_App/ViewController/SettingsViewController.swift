//
//  SettingsViewController.swift
//  ViO_App
//
//  Created by Samet Arabacı on 19.02.2025.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var settingsView: UIView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var themeLabelControl: UILabel!
    @IBOutlet weak var themeViewControl: UIView!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var metricView: UIView!
    @IBOutlet weak var birimSistem: UILabel!
    @IBOutlet weak var birimLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        
        let savedTheme = UserDefaults.standard.string(forKey: "theme") ?? "light"
            applyTheme(savedTheme)
        themeSegmentedControl.selectedSegmentIndex = savedTheme == "Dark" ? 1 : 0
        
        let savedUnitSystem = UserDefaults.standard.string(forKey: "unitSystem") ?? "metric"
        birimLabel.text = savedUnitSystem == "metric" ? "Metric" : "Imperial"
        
        NotificationCenter.default.post(name: Notification.Name("UnitSystemChanged"), object: nil)
        
        let tapMetric = UITapGestureRecognizer(target: self, action: #selector(metricViewTapped))
        metricView.isUserInteractionEnabled = true
        metricView.addGestureRecognizer(tapMetric)
    }
    
    @objc func metricViewTapped(){
        let alert = UIAlertController(title: "Birim Seçimi", message: "Buradan birim sistemini değiştirebilirsiniz.", preferredStyle: .alert)
        
        let metricAction = UIAlertAction(title: "Metric (kg/cm)", style: .default){
            _ in UserDefaults.standard.set("metric", forKey: "unitSystem")
            self.birimLabel.text = "Metric"
            NotificationCenter.default.post(name: Notification.Name("UnitSystemChanged"), object: nil)
        }
        let imperialAction = UIAlertAction(title: "Imperial (lbs/inch)", style: .default){
            _ in  UserDefaults.standard.set("imperial", forKey: "unitSystem")
            self.birimLabel.text = "Imperial"
            NotificationCenter.default.post(name: Notification.Name("UnitSystemChanged"), object: nil)
        }
        
        alert.addAction(metricAction)
        alert.addAction(imperialAction)
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func initUI(){
        settingsLabel.text = "Ayarlar"
        themeLabelControl.text = "Tema Ayarı"
        birimSistem.text = "Birim Sistemi"
        
        viewUI(metricView)
        viewUI(themeViewControl)
        
        settingsView.backgroundColor = UIColor(named: "CustomBackgroundColor")
        themeViewControl.backgroundColor = UIColor(named: "GenderBackgroundColor")
        metricView.backgroundColor = UIColor(named: "GenderBackgroundColor")
    }
    
    private func viewUI(_ view: UIView){
        view.layer.shadowColor = UIColor(named: "CellBackgroundColor")?.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 3
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = false
        view.backgroundColor = UIColor(named: "GenderBackgroundColor")
    }


    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let selectedTheme = selectedIndex == 0 ? "Light" : "Dark"
        UserDefaults.standard.set(selectedTheme, forKey: "theme")
        applyTheme(selectedTheme)
    }
    
    func applyTheme(_ theme: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate,
              let window = delegate.window else { return }

        if theme == "Dark" {
            window.overrideUserInterfaceStyle = .dark
        } else {
            window.overrideUserInterfaceStyle = .light
        }
    }
}
