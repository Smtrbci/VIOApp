//
//  BmiCategory.swift
//  ViO_App
//
//  Created by Samet Arabacı on 23.02.2025.
//

import Foundation

struct BmiCategory {
    let minValue: Double
    let maxValue: Double
    let category: String
    let description: String
    
    static var categories: [BmiCategory] = [
        BmiCategory(minValue: 0, maxValue: 18.4, category: "Zayıf", description: "Kilo almanız önerilir. Dengeli beslenmeye ve yeterli kalori alımına dikkat edin."),
        BmiCategory(minValue: 18.5, maxValue: 24.9, category: "Normal Kilo", description: "Sağlıklı bir kilodasınız. Dengeli beslenmeye ve düzenli egzersize devam edin."),
        BmiCategory(minValue: 25, maxValue: 29.9, category: "Fazla Kilolu", description: "Kilonuzu kontrol altında tutmak için sağlıklı beslenme ve düzenli fiziksel aktivite önerilir."),
        BmiCategory(minValue: 30, maxValue: 34.9, category: "Obez (1.Derece)", description: "Kilo yönetimi için bir uzmandan destek alabilirsiniz. Sağlıklı beslenme ve egzersiz önemlidir."),
        BmiCategory(minValue: 35, maxValue: 39.9, category: "Obez (2.Derece)", description: "Sağlık risklerini azaltmak için doktor ve diyetisyen eşliğinde kilo kontrolü sağlanmalıdır."),
        BmiCategory(minValue: 40, maxValue: Double.infinity, category: "Morbid Obez", description: "Ciddi sağlık riskleri oluşabilir. Uzman eşliğinde tıbbi destek ve yaşam tarzı değişiklikleri önerilir."),
        ]
    
    static func getCategory(for bmi: Double) -> BmiCategory? {
        return categories.first { bmi >= $0.minValue && bmi <= $0.maxValue}
    }
}
