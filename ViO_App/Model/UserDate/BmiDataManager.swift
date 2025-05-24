//
//  BmiDataManager.swift
//  ViO_App
//
//  Created by Samet Arabacı on 25.03.2025.
//

import Foundation

class BmiDataManager {
    
    static func saveBmiResult(bmi: Double, category: String) {
        let bmiData: [String: Any] = ["bmi": bmi, "category": category]
        
        var savedResults = UserDefaults.standard.array(forKey: "BMIResults") as? [[String: Any]] ?? []
        savedResults.append(bmiData)
        
        UserDefaults.standard.set(savedResults, forKey: "BMIResults")
        
        print("📌 BMI Kaydedildi: \(bmi) - \(category)")
    }

    static func loadBmiResults() -> [[String: Any]]? {
        return UserDefaults.standard.array(forKey: "savedBmiResults") as? [[String: Any]]
    }
    
    static func clearBmiResults(for bmi: Double) {
        var savedResults = UserDefaults.standard.array(forKey: "BMIResults") as? [[String: Any]] ?? []
            savedResults.removeAll { ($0["bmi"] as? Double) == bmi }
            UserDefaults.standard.set(savedResults, forKey: "BMIResults")
            print("📌 BMI verisi silindi. Güncellenen liste: \(savedResults)")
        
    }
    
}
