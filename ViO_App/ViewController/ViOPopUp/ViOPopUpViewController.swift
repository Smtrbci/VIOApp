//
//  ViOPopUpViewController.swift
//  ViO_App
//
//  Created by Samet Arabacı on 23.02.2025.
//

// ViOPopUpViewController.swift

import UIKit
import FirebaseAnalytics
import FirebaseCrashlytics

class ViOPopUpViewController: UIViewController {
    
    @IBOutlet weak var bacgroundcolorView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var xMarkImage: UIImageView!
    @IBOutlet weak var popUpLabel: UILabel!
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var bookmarkImage: UIImageView!
    @IBOutlet weak var shareImage: UIImageView!
    
    var currentBmiValue: Double?
    var calculateBmi: String?
    var isBookmarked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("popup_view_shown", parameters: [
            "screen": "ViOPopUpViewController"
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closePopUp))
        xMarkImage.isUserInteractionEnabled = true // image etkilişim izini verdim
        xMarkImage.addGestureRecognizer(tapGesture)
        
        initUI()
    }
    
    private func initUI() {
        showPopUp()
        setPopUp()
        setBmiText()
        setGradeText()
        setbackgroundcolorView()
        bookmarkButtonTapped()
        shareButtonTapped()
    }
    
    private func setbackgroundcolorView() {
        bacgroundcolorView.layer.cornerRadius = 10
        bacgroundcolorView.backgroundColor = UIColor(named: "CustomBackgroundColor")
    }
    
    private func setBmiText() {
        descriptionLabel.layer.cornerRadius = 10
        guard let bmiString = calculateBmi,
              let bmiValue = Double(bmiString),
              let category = BmiCategory.getCategory(for: bmiValue)
        else {
            descriptionLabel.text = "Geçersiz Değer"
            return
        }
        descriptionLabel.text = category.description
    }
    
    private func setGradeText() {
        guard let bmiString = calculateBmi, let bmiValue = Double(bmiString),
              let category = BmiCategory.getCategory(for: bmiValue) else {
            gradeLabel.text = "Geçersiz Değer"
            return
        }
        gradeLabel.text = category.category
    }
    
    private func setPopUp() {
        popUpView.layer.cornerRadius = 10
        popUpView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        popUpView.clipsToBounds = true
        popUpView.backgroundColor = UIColor(named: "GenderBackgroundColor")
    }
    
    @objc func closePopUp() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showPopUp() {
        if let bmiString = calculateBmi, let bmiValue = Double(bmiString) {
            popUpLabel.text = String(format: "%.2f kg/m²", bmiValue)
        } else if let bmiValue = currentBmiValue {
            popUpLabel.text = String(format: "%.2f kg/m²", bmiValue)
        } else {
            popUpLabel.text = "Geçersiz Değer"
        }
    }
    
    func bookmarkButtonTapped() {
        let tapGestureBook = UITapGestureRecognizer(target: self, action: #selector(bookmarkPopUp))
        bookmarkImage.isUserInteractionEnabled = true
        bookmarkImage.addGestureRecognizer(tapGestureBook)
    }
    
    @objc func bookmarkPopUp(){
        
        Analytics.logEvent("bookmark_toggled", parameters: [
            "state": isBookmarked ? "removed" : "added"
        ])
        
        isBookmarked.toggle()
        
        if isBookmarked {
            bookmarkImage.image = UIImage(systemName: "bookmark.fill") // Kaydedildi ikonu
            saveBmi()
        } else {
            bookmarkImage.image = UIImage(systemName: "bookmark") // Normal ikon
            removeBmi()
        }
    }
    
    func saveBmi() {
        guard let bmiValue = currentBmiValue else { return }
        
        let category = BmiCategory.getCategory(for: bmiValue)?.category ?? "Bilinmiyor"
        BmiDataManager.saveBmiResult(bmi: bmiValue, category: category)
        
        Analytics.logEvent("bmi_saved", parameters: [
            "bmi": bmiValue,
            "category": category
        ])
        
        print("BMI sonucu kaydedildi: \(bmiValue) - \(category)")
    }
    
    func removeBmi() {
        guard let bmiValue = currentBmiValue else { return }
        BmiDataManager.clearBmiResults(for: bmiValue)
        Analytics.logEvent("bmi_removed", parameters: [
            "bmi": bmiValue
        ])
        print("BMI sonucu silindi.")
    }
    
    
    func shareButtonTapped() {
        let tapGestureShare = UITapGestureRecognizer(target: self, action: #selector(sharePopUp))
        shareImage.isUserInteractionEnabled = true
        shareImage.addGestureRecognizer(tapGestureShare)
    }
    
    @objc func sharePopUp() {
        
        Analytics.logEvent("bmi_shared", parameters: [
            "bmi_value": currentBmiValue ?? -1
        ])
        let storyboard = UIStoryboard(name: "ShareView", bundle: nil)
        if let shareViewController = storyboard.instantiateViewController(withIdentifier: "ShareViewController") as? ShareViewController {
            var bmiString = "0.00"
            var descriptionText = "Bilinmiyor"

            if let bmiValue = currentBmiValue {
                bmiString = String(format: "%.2f", bmiValue)
                if let category = BmiCategory.getCategory(for: bmiValue) {
                    descriptionText = category.description
                }
            }

            shareViewController.bmiValue = Double(bmiString) ?? 0.0
            shareViewController.descriptionText = descriptionText
            
            shareViewController.view.layoutIfNeeded()

            if let shareView = shareViewController.shareView,
               let image = convertViewToImage(view: shareView),
               let imageData = image.pngData() {

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
                let dateString = dateFormatter.string(from: Date())

                let safeBmiString = bmiString.replacingOccurrences(of: " ", with: "")
                                             .replacingOccurrences(of: "/", with: "-")
                                             .replacingOccurrences(of: "m²", with: "m2")

                let fileName = "Bmi_\(safeBmiString)kg-m2_\(dateString).png"

                if let fileURL = saveImageToDocuments(imageData: imageData, fileName: fileName) {
                    print("Görsel kaydedildi: \(fileName)")

                    let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                    present(activityViewController, animated: true, completion: nil)
                }
            } else {
                let error = NSError(domain: "ViO_App", code: 3001, userInfo: [
                    NSLocalizedDescriptionKey: "Paylaşım sırasında view nil ya da görsel oluşturulamadı"
                ])
                Crashlytics.crashlytics().record(error: error)

                print("ShareView is nil veya görsel oluşturulamadı.")
            }
        }
    }

    
    func saveImageToDocuments(imageData: Data, fileName: String) -> URL? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            try imageData.write(to: fileURL)
            return fileURL
        } catch {
            print("Dosya oluşturmada hata oluştu: \(error)")
            return nil
        }
    }
    
    func convertViewToImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            let error = NSError(domain: "ViO_App", code: 3002, userInfo: [
                NSLocalizedDescriptionKey: "Görsel render için context alınamadı"
            ])
            Crashlytics.crashlytics().record(error: error)
            return nil
        }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

