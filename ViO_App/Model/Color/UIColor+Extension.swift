//
//  UIColor+Extension.swift
//  ViO_App
//
//  Created by Samet Arabacı on 23.02.2025.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        let scanner = Scanner(string: hexSanitized)
        scanner.scanHexInt64(&rgb)

        let length = hexSanitized.count
        let r, g, b: CGFloat

        if length == 6 {
            r = CGFloat((rgb >> 16) & 0xFF) / 255.0
            g = CGFloat((rgb >> 8) & 0xFF) / 255.0
            b = CGFloat(rgb & 0xFF) / 255.0
        } else {
            self.init(white: 0.0, alpha: 1.0)
            return
        }

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

