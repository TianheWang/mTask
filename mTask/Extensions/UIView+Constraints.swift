//
//  UIView+Constraints.swift
//  mTask
//
//  Created by Tianhe Wang on 1/28/18.
//  Copyright © 2018 Tianhe Wang. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
  func constrainTo(parentView: UIView) {
    topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
    leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
    trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
    bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
  }
}
