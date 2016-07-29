//
//  BorderTextView.swift
//  AnxietyTracker
//
//  Created by Ryan Walsh on 7/28/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
	public func addBorder() {
		self.layer.borderWidth = 1
		self.layer.borderColor = UIColor.lightGrayColor().CGColor
		self.layer.cornerRadius = 3
	}
}