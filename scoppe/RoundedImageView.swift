//
//  RoundedImageView.swift
//  scoppe
//
//  Created by Billy Cauchy-Tharin on 21/01/2021.
//

import UIKit

class RoundedImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2.0
    }
}

