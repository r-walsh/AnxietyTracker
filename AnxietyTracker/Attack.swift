//
//  Attack.swift
//  AnxietyTracker
//
//  Created by Ryan Walsh on 7/29/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import Foundation

struct Attack {
	private let causeKey = "cause"
	private let dateKey = "date"
	private let dateDisplayStringKey = "dateDisplayString"
	private let durationKey = "duration"
	private let managedByKey = "managedBy"
	private let postAttackSeverityKey = "postAttackSeverity"
	private let severityKey = "severity"

	let date: NSDate
	let duration: NSTimeInterval
	let dateDisplayString: String
	let severity: Int
	let postAttackSeverity: Int
	let cause: String
	let managedBy: String

	var attackAsDictionary: [ String:AnyObject ] {
		return [
				dateKey: date,
				durationKey: duration,
				dateDisplayStringKey: dateDisplayString,
				severityKey: severity,
				postAttackSeverityKey: postAttackSeverity,
				causeKey: cause,
				managedByKey: managedBy
		]
	}

	init( date: NSDate, duration: NSTimeInterval, dateDisplayString: String, severity: Int, postAttackSeverity: Int, cause: String, managedBy: String ) {
		self.date = date
		self.duration = duration
		self.dateDisplayString = dateDisplayString
		self.severity = severity
		self.postAttackSeverity = postAttackSeverity
		self.cause = cause
		self.managedBy = managedBy
	}

	init?( attackDictionary: [ String:AnyObject ] ) {
		guard let date = attackDictionary[ dateKey ] as? NSDate,
		let duration = attackDictionary[ durationKey ] as? NSTimeInterval,
		let dateDisplayString = attackDictionary[ dateDisplayStringKey ] as? String,
		let severity = attackDictionary[ severityKey ] as? Int,
		let postAttackSeverity = attackDictionary[ postAttackSeverityKey ] as? Int,
		let cause = attackDictionary[ causeKey ] as? String,
		let managedBy = attackDictionary[ managedByKey ] as? String
		else {
			return nil
		}

		self.date = date
		self.duration = duration
		self.dateDisplayString = dateDisplayString
		self.severity = severity
		self.postAttackSeverity = postAttackSeverity
		self.cause = cause
		self.managedBy = managedBy
	}
}
