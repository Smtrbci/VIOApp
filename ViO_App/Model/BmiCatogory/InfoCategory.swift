//
//  InfoCategory.swift
//  ViO_App
//
//  Created by Samet Arabacı on 1.04.2025.
//

import Foundation

struct InfoCategory {
    let minData: Double
    let maxData: Double
    let categories: String
    let advice: String
    let recommendations: [String]
}

struct InfoBmiCategories {
    static let categori: [InfoCategory] = [
        InfoCategory(minData: 0, maxData: 18.4, categories: "ℹ️ Zayıf", advice: "⚠️ Vücut kitle indeksi 18.4'ten düşük olan bireyler zayıf kategorisinde yer alır. Bu durum, yetersiz beslenme veya vücudun ihtiyacı olan besinleri yeterince almamasıyla ilişkili olabilir.", recommendations: [
            "📌 Yeterli ve dengeli beslenmeye özen gösterin.",
            "📌 Protein, karbonhidrat ve sağlıklı yağları içeren çeşitli besinler tüketin.",
            "📌 Kas kütlenizi artırmak için direnç egzersizlerine yönelebilirsiniz."
        ]),
        InfoCategory(minData: 18.5, maxData: 24.9, categories: "ℹ️ Normal Kilo", advice: "⚠️ BMI'niz bu aralıktaysa, vücudunuz ideal kiloda demektir. Genel sağlık açısından en uygun aralıklardan biridir.", recommendations: [
            "📌 Dengeli beslenmeye ve fiziksel aktiviteye devam edin.",
            "📌 Şekerli ve işlenmiş gıdalardan uzak durun.",
            "📌 Stresten uzak durmaya ve kaliteli uyku uyumaya özen gösterin."
        ]),
        InfoCategory(minData: 25, maxData: 29.9, categories: "ℹ️ Fazla Kilolu", advice: "⚠️ BMI'niz 25'in üzerindeyse, fazla kilolu sınıfına girebilirsiniz. Bu durum, ilerleyen dönemlerde obeziteye dönüşebileceği için dikkat edilmesi gereken bir sınırdır.", recommendations: [
            "📌 Kalori alımınızı kontrol altında tutun.",
            "📌 Fiziksel aktivitelerinizi artırın (yürüyüş, bisiklet, yüzme vb.).",
            "📌 Yağ ve şeker oranı yüksek gıdalardan kaçının."
        ]),
        InfoCategory(minData: 30, maxData: 34.9, categories: "ℹ️ Obez (1. Derece)", advice: "⚠️ Obezite, kalp hastalıkları, diyabet, hipertansiyon gibi ciddi sağlık sorunlarıyla ilişkili olabilir. BMI 30'un üzerine çıktığında bu riskler artar.", recommendations: [
            "📌 Bir beslenme uzmanından veya doktordan destek alın.",
            "📌 Diyetinizi sağlıklı besinlerle zenginleştirin.",
            "📌 Egzersiz programlarına başlayarak kilo kontrolü sağlayın."
        ]),
        InfoCategory(minData: 35, maxData: 39.9, categories: "ℹ️ Obez (2. Derece)", advice: "⚠️ Bu seviyede obezite, ciddi sağlık sorunları yaratabilir. Kalp-damar hastalıkları ve tip 2 diyabet riski oldukça yüksektir.", recommendations: [
            "📌 Mutlaka bir doktor kontrolüne gidin.",
            "📌 Kilo kontrolü için uzun vadeli bir plan yapın.",
            "📌 Diyetisyen eşliğinde beslenme programı oluşturun."
        ]),
        InfoCategory(minData: 40, maxData: Double.infinity, categories: "ℹ️ Morbid Obez", advice: "⚠️ Morbid obezite, yaşam kalitesini ciddi şekilde düşürebilir ve sağlık risklerini büyük ölçüde artırabilir. Hareket kabiliyetinde azalma, uyku apnesi, kalp hastalıkları gibi sorunlar ortaya çıkabilir.", recommendations: [
            "📌 Bir uzman eşliğinde medikal destek alın.",
            "📌 Gerekirse cerrahi yöntemler (mide küçültme ameliyatı gibi) değerlendirilebilir.",
            "📌 Beslenme ve yaşam tarzınızda köklü değişiklikler yapın."
        ])
    ]
}

