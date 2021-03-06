//
//  AttackDetailViewController.swift
//  AnxietyTracker
//
//  Created by Ryan Walsh on 7/29/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class AttackDetailViewController: UIViewController {

	var attack: Attack?

	@IBOutlet weak var navItem: UINavigationItem!
	@IBOutlet weak var causeOfAttackTextView: UITextView!
	@IBOutlet weak var managedAttackByTextView: UITextView!
	@IBOutlet weak var attackSeverityLabel: UILabel!
	@IBOutlet weak var postAttackSeverityLabel: UILabel!
	@IBOutlet weak var attackDurationLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		if let attack = attack {
			navItem.title = attack.dateDisplayString
			causeOfAttackTextView.text = attack.cause
			managedAttackByTextView.text = attack.managedBy
			attackSeverityLabel.text = "In attack severity: \( attack.severity )"
			postAttackSeverityLabel.text = "Post attack severity: \( attack.postAttackSeverity )"
			attackDurationLabel.text = formatDuration( attack.duration )
		}
	}

	func formatDuration( duration: NSTimeInterval ) -> String {
		let hours = duration / 3600
		let minutes = ( duration / 60 ) % 60
		let seconds = duration % 60

		if hours > 1 {
			return "Attack Duration: \( Int( round( hours ) ) ) hours"
		}

		if minutes > 1 {
			return "Attack Duration: \( Int( round( minutes ) ) ) minutes"
		}

		return "Attack Duration: \( Int( round( seconds ) ) ) seconds"
	}

	@IBAction func trashButtonPressed( sender: UIBarButtonItem ) {
		if let currentAttack = attack {
			let confirmDelete = UIAlertController( title: "Are you sure?", message: "This action cannot be undone.", preferredStyle: .Alert )

			let deleteAction = UIAlertAction( title: "Delete", style: .Destructive, handler: {
				(action) in
				AttackController.sharedController.deleteFromCoreData( currentAttack.uuid, completion: {
					(success: Bool) in
					if success {
						self.navigationController?.popViewControllerAnimated( true )
					}
				} )
			} )

			confirmDelete.addAction( deleteAction )
			confirmDelete.addAction( UIAlertAction( title: "Cancel", style: .Cancel, handler: nil ) )

			self.presentViewController( confirmDelete, animated: true, completion: nil )
		}
	}

}
