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
	private let uuidKey = "uuid"

	private let managedContext: NSManagedObjectContext

	var attacks: [ Attack ] = []
	var coreDataAttacks = [ NSManagedObject ]()

	private var attackStartTime: NSTimeInterval?
	private var attackDuration: NSTimeInterval?

	init() {
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		managedContext = appDelegate.managedObjectContext

		fetchAttacksFromCoreData()
	}

	func createAttack( attackSeverity: Int, postAttackSeverity: Int, causeOfAttack: String, managedAttackBy: String ) -> Attack {
		let currentDate = NSDate()
		let dateDisplayString = formatNSDateToDisplayString( currentDate )
		let duration = attackDuration == nil ? 0 : attackDuration!
		let uuid = NSUUID().UUIDString

		let attack = Attack(
				date: currentDate,
				duration: duration,
				dateDisplayString: dateDisplayString,
				severity: attackSeverity,
				postAttackSeverity: postAttackSeverity,
				cause: causeOfAttack,
				managedBy: managedAttackBy,
				uuid: uuid
				)

		attacks.insert( attack, atIndex: 0 )
		saveAttackToCoreData( attack )
		return attack
	}

	func saveAttackToCoreData( attack: Attack ) {
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
						severityKey: attack.valueForKey( severityKey )!,
						uuidKey: attack.valueForKey( uuidKey )!
				] )!
			} ).sort( { $0.date.compare( $1.date ) == NSComparisonResult.OrderedDescending } )
		} catch {
			print( "Could not fetch attacks: \( error )" )
		}
	}

	func deleteFromCoreData( uuid: String, completion: ( ( Bool ) -> Void )? = nil ) {
		let predicate = NSPredicate( format: "uuid == %@", uuid )

		let fetchRequest = NSFetchRequest( entityName: "Attack" )
		fetchRequest.predicate = predicate

		do {
			let attacks = try self.managedContext.executeFetchRequest( fetchRequest ) as! [ NSManagedObject ]
			if let attackToDelete = attacks.first {
				self.managedContext.deleteObject( attackToDelete )
			}
		} catch {
			print( "Failed to delete: \( error )" )
			if let callback = completion {
				callback( false )
			}
		}

		do {
			try self.managedContext.save()
			self.attacks = self.attacks.filter {
				$0.uuid != uuid
			}

			if let callback = completion {
				callback( true )
			}
		} catch {
			print( "Failed to delete: \( error )" )
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
