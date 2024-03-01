//
//  Extension+UIStackView.swift
//  Weather
//
//  Created by Алексей Однолько on 21.02.2024.
//

import UIKit

extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis,
                     alignment: UIStackView.Alignment = .fill,
                     distribution: UIStackView.Distribution = .fill,
                     spacing: CGFloat = 0,
                     arrangedSubviews: [UIView]? = nil) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        if let arrangedSubviews = arrangedSubviews {
            self.addArrangedSubview(views: arrangedSubviews)
        }
    }
    
    func addArrangedSubview(views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
