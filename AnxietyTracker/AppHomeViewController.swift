//
//  AppHomeViewController.swift
//  AnxietyTracker
//
//  Created by Ryan Walsh on 7/28/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class AppHomeViewController: UIViewController {

	let attackCtrl = AttackController.sharedController

	@IBOutlet weak var timeSinceLastAttackLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear( animated: Bool ) {
		if attackCtrl.attacks.count == 0 {
			timeSinceLastAttackLabel.text = "You haven't had any attacks so far!"
		} else {
			timeSinceLastAttackLabel.text = formatDateToTimeSinceLastAttack( attackCtrl.attacks[ 0 ].date )
		}
	}

	func formatDateToTimeSinceLastAttack( date: NSDate ) -> String {
		let timeIntervalSinceLastAttack = NSDate().timeIntervalSinceDate( date )
		let days = timeIntervalSinceLastAttack / 86400
		let hours = timeIntervalSinceLastAttack / 3600

		if days > 365 {
			return "It has been over a year since your last attack!"
		}

		if days > 1 && days < 2 {
			return "It has been one day since your last attack"
		}

		if days > 2 {
			return "It has been \( Int( round( days ) ) ) days since your last attack"
		}

		if hours > 1 && hours < 2 {
			return "It has been one hour since your last attack"
		}

		if hours > 2 {
			return "It has been \( Int( round( hours ) ) ) hours since your last attack"
		}

		return "It has been less than an hour since your last attack"

	}

	@IBAction func havingAttackButtonPressed( sender: UIButton ) {
		attackCtrl.attackStarted()
		performSegueWithIdentifier( "showAttackInformation", sender: nil )
	}

	// MARK: - Navigation

	@IBAction func unwindToHome( segue: UIStoryboardSegue ) {
	}

}
