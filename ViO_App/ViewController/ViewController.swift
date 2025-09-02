//
//  ViewController.swift
//  ViO_App
//
//  Created by Samet Arabacı on 19.02.2025.
//

import UIKit
import FirebaseAnalytics
import FirebaseCrashlytics

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{

    @IBOutlet var vioViewControllerView: UIView!
    @IBOutlet weak var vioButton: UIButton!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageview: UIView!
    @IBOutlet weak var weightPicker: UIPickerView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var heightPicker: UIPickerView!
    @IBOutlet weak var genderCollectionView: UICollectionView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var viewLabel: UILabel!
    
    let heightArry = Array(100...250)
    let weightArry = Array(20...200)
    
    let heightArrayInch = Array(39...98)
    let weightArrayLbs = Array(45...440)
    
    var selectedGenderIndex: IndexPath?
    var ageValue: Int?
    
    var hasShownPopup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderCollectionView.delegate = self
        genderCollectionView.dataSource = self
        
        heightPicker.delegate = self
        heightPicker.dataSource = self
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        
        Analytics.setUserID("tester_\(UUID().uuidString.prefix(8))")
        Analytics.setUserProperty("iOS", forName: "platform")
        Analytics.logEvent("app_start", parameters: [
                        "screen": "ViewController",
                        "timestamp":"\(Date())"
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(unitSystemChanged), name: Notification.Name("UnitSystemChanged"), object: nil)
        
        if let layout = genderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumLineSpacing = 30
                layout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
                layout.itemSize = CGSize(width: (genderCollectionView.frame.width - 60) / 2, height: 100)
            }
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !hasShownPopup {
                hasShownPopup = true
            let hasSelectedUnit = UserDefaults.standard.string(forKey: "unitSystem") != nil
                    if !hasSelectedUnit {
                        showUnitSelectionPopup()
                    } else {
                        checkUnitSystem()
                    }
            }
    }
    
    private func initUI(){
        viewLabel.text = "Vücut İndex Ölçümü"
        heightLabel.text = "Boy"
        weightLabel.text = "Kilo"
        age.text = "Yaş"
        ageLabel.text = "0"
        viewUI(heightView)
        viewUI(genderView)
        viewUI(weightView)
        viewUI(ageview)
        //positiveButton.setTitleColor(.black, for: .normal)
        vioViewControllerView.backgroundColor = UIColor(named: "CustomBackgroundColor") // ArkaPlan Rengi
        genderCollectionView.backgroundColor = UIColor(named: "GenderBackgroundColor") // Cinsiyetin ArkaPlan Rengi
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
    
    @objc func unitSystemChanged(){
        checkUnitSystem()
    }
    
    
    func checkUnitSystem(){
        guard let selectedUnit = UserDefaults.standard.string(forKey: "unitSystem") else {
            showUnitSelectionPopup()
            return
        }
        applyUnitSystem(selectedUnit)
    }
    
    func showUnitSelectionPopup(){
        let alert = UIAlertController(title: "Birim Seçimi", message: "Hangi birim sistemini kullanmak istersiniz?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Metric (kg/cm)", style: .default, handler: { _ in
                UserDefaults.standard.set("metric", forKey: "unitSystem")
                self.applyUnitSystem("metric")
            }))
            
            alert.addAction(UIAlertAction(title: "Imperial (lbs/inch)", style: .default, handler: { _ in
                UserDefaults.standard.set("imperial", forKey: "unitSystem")
                self.applyUnitSystem("imperial")
            }))
            
            present(alert, animated: true, completion: nil)
    }
    
    func applyUnitSystem(_ unit: String) {
        
        Analytics.logEvent("unit_selected", parameters: [
            "unit": unit // metric / imperial
        ])
        
        if unit == "metric" {
            heightLabel.text = "Boy"
            weightLabel.text = "Kilo"
        }
        heightPicker.reloadAllComponents()
        weightPicker.reloadAllComponents()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genderData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenderCollectionViewCell", for: indexPath) as! GenderCollectionViewCell
        
        cell.setup(with: genderData[indexPath.row])
        cell.layer.borderColor = UIColor(named: "CellBackgroundColor")?.cgColor
        cell.layer.borderWidth = 1
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor(named: "GenderBackgroundColor")
        
        
        if selectedGenderIndex == indexPath {
            cell.layer.borderColor = UIColor(named: "CellGenderBackgroundColor")?.cgColor
            cell.layer.borderWidth = 2
            cell.layer.masksToBounds = false
            cell.layer.cornerRadius = 10
            //cell.genderLabel.textColor = .black
        } else {
            cell.layer.borderColor = UIColor(named: "GenderBackgroundColor")?.cgColor
            //cell.genderLabel.textColor = .black
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Analytics.logEvent("gender_selected", parameters: [
            "selected_gender_index": indexPath.row
        ])
        
        if selectedGenderIndex == indexPath{
            selectedGenderIndex = nil
        } else {
            selectedGenderIndex = indexPath
        }
        collectionView.reloadData()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let unit = UserDefaults.standard.string(forKey: "unitSystem") ?? "metric"
        if pickerView == heightPicker {
            return unit == "metric" ? heightArry.count : heightArrayInch.count
        } else {
            return unit == "metric" ? weightArry.count : weightArrayLbs.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let unit = UserDefaults.standard.string(forKey: "unitSystem") ?? "metric"
        
        if pickerView == heightPicker {
            if unit == "metric" {
                return "\(heightArry[row]) cm"
            } else {
                let inches = heightArrayInch[row]
                let feet = inches / 12
                let remainingInches = inches % 12
                return "\(inches) in (\(feet)'\(remainingInches)\")"
            }
        } else {
            return unit == "metric" ? "\(weightArry[row]) kg" : "\(weightArrayLbs[row]) lbs"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let unit = UserDefaults.standard.string(forKey: "unitSystem") ?? "metric"
        
        Analytics.logEvent("height_or_weight_selected", parameters: [
            "picker_type": pickerView == heightPicker ? "height" : "weight",
            "value": pickerView == heightPicker
                ? (UserDefaults.standard.string(forKey: "unitSystem") == "metric" ? heightArry[row] : heightArrayInch[row])
                : (UserDefaults.standard.string(forKey: "unitSystem") == "metric" ? weightArry[row] : weightArrayLbs[row])
        ])
        
        if pickerView == heightPicker {
            let value = unit == "metric" ? "Boyum: \(heightArry[row]) cm" : "Boyum: \(heightArrayInch[row]) in"
                heightLabel.text = value
            } else {
            let value = unit == "metric" ? "Kilom: \(weightArry[row]) kg" : "Kilom: \(weightArrayLbs[row]) lbs"
                weightLabel.text = value
            }
        }
    
    @IBAction func negativeButtonTapped(_ sender: Any) {
        
        Analytics.logEvent("age_changed", parameters: [
            "new_age": age
        ])
        
        var age = Int(ageLabel.text ?? "0") ?? 0
        if age > 1 {
            age -= 1
            ageLabel.text = "\(age)"
            ageValue = age
        }
        
    }
    @IBAction func positiveButtonTapped(_ sender: Any) {
        
        Analytics.logEvent("age_changed", parameters: [
            "new_age": age
        ])
        
        var age = Int(ageLabel.text ?? "0") ?? 0
        if age < 120 {
            age += 1
            ageLabel.text = "\(age)"
            ageValue = age
        }
        
    }
    
    func calculateBmi() -> Double {
        let unit = UserDefaults.standard.string(forKey: "unitSystem") ?? "metric"
        
        if unit == "metric" {
            let height = Double(heightArry[heightPicker.selectedRow(inComponent: 0)]) / 100
            let weight = Double(weightArry[weightPicker.selectedRow(inComponent: 0)])
            let bmi = weight / (height * height)
            return bmi
        }else{
            let height = Double(heightArrayInch[heightPicker.selectedRow(inComponent: 0)])
            let weight = Double(weightArrayLbs[weightPicker.selectedRow(inComponent: 0)])
            let bmi = (weight / (height * height)) * 703
            return bmi
        }
    }
    
    @IBAction func vioButtonTapped(_ sender: Any) {
        let error = NSError(domain: "ViO_App", code: 1001, userInfo: [
            NSLocalizedDescriptionKey: "Cinsiyet veya yaş girilmedi"
        ])
        Crashlytics.crashlytics().record(error: error)
        
        
        guard (selectedGenderIndex != nil) else {
                showAlert(message: "Cinsiyet seçiniz.")
                return
            }

            guard let age = ageValue, age > 0 else {
                showAlert(message: "Yaş seçiniz.")
                return
            }
            
            let bmi = calculateBmi()
        
            Analytics.logEvent("bmi_calculated", parameters: [
                "selected_gender": selectedGenderIndex?.row ?? -1,
                "age": ageValue ?? 0,
                "bmi_value": bmi
            ])
            
            let bmiString = String(format: "%.2f", bmi)
            let category = BmiCategory.getCategory(for: bmi)?.category ?? "Bilinmiyor"
        
            Analytics.logEvent("bmi_category_detected", parameters: [
                "category": category
            ])
            
            
            if let profileVC = navigationController?.viewControllers.first(where: { $0 is ProfileTableViewController }) as? ProfileTableViewController {
                profileVC.loadBmiData()            }
            
            let storyboard = UIStoryboard(name: "ViOPopUp", bundle: nil)
            if let vioVC = storyboard.instantiateViewController(withIdentifier: "ViOPopUpViewController") as? ViOPopUpViewController {
                vioVC.calculateBmi = bmiString
                vioVC.currentBmiValue = bmi
                vioVC.modalPresentationStyle = .overFullScreen
                vioVC.modalTransitionStyle = .crossDissolve
                Analytics.logEvent("popup_shown", parameters: [
                    "screen": "ViOPopUpViewController"
                ])
                present(vioVC, animated: true, completion: nil)
            }
    }
    
    func saveShowAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true, completion: nil)
    }


        
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }


