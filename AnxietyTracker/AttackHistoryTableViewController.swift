//
//  AttackHistoryTableViewController.swift
//  AnxietyTracker
//
//  Created by Ryan Walsh on 7/29/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class AttackHistoryTableViewController: UITableViewController {

	let attackCtrl = AttackController.sharedController

	override func viewWillAppear( animated: Bool ) {
		tableView.reloadData()
	}

	// MARK: - Table view data source

	override func tableView( tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
		return attackCtrl.attacks.count
	}

	override func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath ) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier( "pastAttackCell", forIndexPath: indexPath ) as! PastAttackTableViewCell

		cell.attackDateLabel.text = attackCtrl.attacks[ indexPath.row ].dateDisplayString
		cell.attackSeverityLabel.text = "Severity: \( attackCtrl.attacks[ indexPath.row ].severity )"

		return cell
	}

	override func tableView( tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath ) -> Bool {
		return true
	}

	override func tableView( tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath ) {
		if editingStyle == .Delete {
			attackCtrl.deleteFromCoreData( attackCtrl.attacks[ indexPath.row ].uuid, completion: {
				(success: Bool) in
				if success {
					tableView.deleteRowsAtIndexPaths( [ indexPath ], withRowAnimation: .Automatic )
				}
			} )
		}
	}

	// MARK: - Navigation

	override func prepareForSegue( segue: UIStoryboardSegue, sender: AnyObject? ) {
		if segue.identifier == "showAttackDetail" {
			if let destination = segue.destinationViewController as? AttackDetailViewController, indexPath = self.tableView.indexPathForSelectedRow {
				destination.attack = attackCtrl.attacks[ indexPath.row ]
			}
		}
	}

}
