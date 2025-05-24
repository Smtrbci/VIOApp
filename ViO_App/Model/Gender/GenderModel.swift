//
//  GenderModel.swift
//  ViO_App
//
//  Created by Samet Arabacı on 21.02.2025.
//

import Foundation
import UIKit


struct GenderModel {
    let title: String
    let image: UIImage
}

struct User {
    var gender: String
    var height: Int
    var weight: Int
    var age: Int
}

let genderData: [GenderModel] = [
    .init(title: "Erkek", image: UIImage(named: "male")!),
    .init(title: "Kadın", image: UIImage(named: "female")!)
]
