//
// Created by Ryan Walsh on 7/29/16.
// Copyright (c) 2016 Ryan Walsh. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AttackController {
	static let sharedController = AttackController()

	private let causeKey = "cause"
	private let dateKey = "date"
	private let dateDisplayStringKey = "dateDisplayString"
	private let durationKey = "duration"
	private let managedByKey = "managedBy"
	private let postAttackSeverityKey = "postAttackSeverity"
	private let severityKey = "severity"

	var attacks: [ Attack ] = []
	var coreDataAttacks = [ NSManagedObject ]()

	private var attackStartTime: NSTimeInterval?
	private var attackDuration: NSTimeInterval?

	init() {
		fetchAttacksFromCoreData()
	}

	func createAttack( attackSeverity: Int, postAttackSeverity: Int, causeOfAttack: String, managedAttackBy: String ) -> Attack {
		let currentDate = NSDate()
		let dateDisplayString = formatNSDateToDisplayString( currentDate )
		let duration = attackDuration == nil ? 0 : attackDuration!

		let attack = Attack(
				date: currentDate,
				duration: duration,
				dateDisplayString: dateDisplayString,
				severity: attackSeverity,
				postAttackSeverity: postAttackSeverity,
				cause: causeOfAttack,
				managedBy: managedAttackBy
				)

		attacks.append( attack )
		saveAttackToCoreData( attack )
		return attack
	}

	func saveAttackToCoreData( attack: Attack ) {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext

		let entity = NSEntityDescription.entityForName( "Attack", inManagedObjectContext: managedContext )
		let attackEntity = NSManagedObject( entity: entity!, insertIntoManagedObjectContext: managedContext )

		attackEntity.setValuesForKeysWithDictionary( attack.attackAsDictionary )

		do {
			try managedContext.save()
		} catch {
			print( "Could not save attack: \( error )" )
		}
	}

	func fetchAttacksFromCoreData() {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let managedContext = appDelegate.managedObjectContext

		do {
			let results = try managedContext.executeFetchRequest( NSFetchRequest( entityName: "Attack" ) )
			attacks = results.map( {
				(attack) -> Attack in
				return Attack( attackDictionary: [
						causeKey: attack.valueForKey( causeKey )!,
						dateKey: attack.valueForKey( dateKey )!,
						dateDisplayStringKey: attack.valueForKey( dateDisplayStringKey )!,
						durationKey: attack.valueForKey( durationKey )!,
						managedByKey: attack.valueForKey( managedByKey )!,
						postAttackSeverityKey: attack.valueForKey( postAttackSeverityKey )!,
						severityKey: attack.valueForKey( severityKey )!
				] )!
			} ).sort( { $0.date.compare( $1.date ) == NSComparisonResult.OrderedDescending } )
		} catch {
			print( "Could not fetch attacks: \( error )" )
		}
	}

	func formatNSDateToDisplayString( date: NSDate ) -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "MMM dd, yyyy"

		return dateFormatter.stringFromDate( date )
	}

	func attackStarted() {
		attackStartTime = NSDate.timeIntervalSinceReferenceDate()
	}

	func attackFinished() {
		if let startTime = attackStartTime {
			attackDuration = NSDate.timeIntervalSinceReferenceDate() - startTime
		}
	}

}
