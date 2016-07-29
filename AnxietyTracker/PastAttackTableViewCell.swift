//
//  PastAttackTableViewCell.swift
//  AnxietyTracker
//
//  Created by Ryan Walsh on 7/29/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class PastAttackTableViewCell: UITableViewCell {

	@IBOutlet weak var attackDateLabel: UILabel!
	@IBOutlet weak var attackSeverityLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected( selected: Bool, animated: Bool ) {
		super.setSelected( selected, animated: animated )
	}

}
