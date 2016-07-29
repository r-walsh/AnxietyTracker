//
//  AttackInformationViewController.swift
//  AnxietyTracker
//
//  Created by Ryan Walsh on 7/28/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class AttackInformationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {

	@IBOutlet weak var severityOfAttackView: UIView!
	@IBOutlet weak var causeOfAttackView: UIView!
	@IBOutlet weak var waitingView: UIView!

	@IBOutlet weak var severityRatingPicker: UIPickerView!

	@IBOutlet weak var causeOfAttackTextView: UITextView!

	@IBOutlet weak var thoughtExercisesLabel: UILabel!

	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var feelingBetterButton: UIButton!


	private enum AttackInformationState: String {
		case CauseOfAttack, SeverityOfAttack, Waiting
	}

	private var state: AttackInformationState = .CauseOfAttack

	private var timer: NSTimer?

	private var thoughtExercises = [ "Breath deeply", "You are in control", "This is temporary", "You are ok", "Ground yourself" ]
	private var thoughtExercisesIndex = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		causeOfAttackTextView.addBorder()

		feelingBetterButton.layer.borderWidth = 1
		feelingBetterButton.layer.borderColor = UIColor( red: 0.04, green: 0.77, blue: 0.00, alpha: 1.0 ).CGColor
		feelingBetterButton.layer.cornerRadius = 3

		backButton.enabled = false

		severityRatingPicker.dataSource = self
		severityRatingPicker.delegate = self

		causeOfAttackTextView.delegate = self

		severityOfAttackView.layer.opacity = 0
		waitingView.layer.opacity = 0
		causeOfAttackView.layer.opacity = 1
	}

	func createTimer() -> NSTimer {
		return NSTimer.scheduledTimerWithTimeInterval( 5, target: self, selector: #selector( animateThoughtExercise ), userInfo: nil, repeats: true )
	}

	func animateOut( view: UIView, duration: NSTimeInterval = 0.5, completion: ( Bool -> Void )? ) {
		UIView.animateWithDuration( 0.5, animations: {
			view.layer.opacity = 0
		}, completion: completion )
	}

	func animateIn( view: UIView, duration: NSTimeInterval = 0.5 ) {
		UIView.animateWithDuration( duration, delay: 0.5, options: .CurveLinear, animations: {
			view.layer.opacity = 1
		}, completion: nil )
	}

	func cycleThoughtExercises( completion: Bool ) {
		if thoughtExercisesIndex + 1 == thoughtExercises.count {
			thoughtExercisesIndex = 0
		} else {
			thoughtExercisesIndex += 1
		}
		thoughtExercisesLabel.text = thoughtExercises[ thoughtExercisesIndex ]
		animateIn( thoughtExercisesLabel, duration: 0.75 )
	}

	func animateThoughtExercise() {
		animateOut( thoughtExercisesLabel, duration: 0.75, completion: cycleThoughtExercises )
	}

	// MARK: - UITextViewDelegate
	func textView( textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String ) -> Bool {
		if text == "\n" {
			textView.resignFirstResponder()
			return false
		}
		return true
	}

	// MARK: - UIPickerViewDataSource/Delegate
	func numberOfComponentsInPickerView( pickerView: UIPickerView ) -> Int {
		return 1
	}

	func pickerView( pickerView: UIPickerView, numberOfRowsInComponent component: Int ) -> Int {
		return 10
	}

	func pickerView( pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int ) -> String? {
		// Account for 0 index
		return "\( row + 1 )"
	}

	// MARK: - Actions

	@IBAction func doneButtonPressed( sender: UIButton ) {
		switch state {
			case .CauseOfAttack:
				animateOut( causeOfAttackView, completion: nil )
				animateIn( severityOfAttackView )
				backButton.enabled = true
				state = .SeverityOfAttack
				break
			case .SeverityOfAttack:
				state = .Waiting
				doneButton.enabled = false
				doneButton.setTitleColor( UIColor.lightGrayColor(), forState: .Normal )
				animateOut( severityOfAttackView, completion: nil )
				animateIn( waitingView )
				timer = createTimer()
				timer!.fire()
				break
			case .Waiting:
				break
		}
	}

	@IBAction func backButtonPressed( sender: UIButton ) {
		switch state {
			case .CauseOfAttack:
				break
			case .SeverityOfAttack:
				animateOut( severityOfAttackView, completion: nil )
				animateIn( causeOfAttackView )
				backButton.enabled = false
				state = .CauseOfAttack
				break
			case .Waiting:
				state = .SeverityOfAttack
				doneButton.enabled = true
				doneButton.setTitleColor( UIColor( red: 0.04, green: 0.77, blue: 0.00, alpha: 1.0 ), forState: .Normal )
				animateOut( waitingView, completion: nil )
				animateIn( severityOfAttackView )
				timer!.invalidate()
				break
		}
	}

	@IBAction func feelingBetterButtonPressed( sender: UIButton ) {
		timer!.invalidate()
		AttackController.sharedController.attackFinished()
		self.performSegueWithIdentifier( "showPostAttack", sender: nil )
	}

	// MARK: - Navigation
	override func prepareForSegue( segue: UIStoryboardSegue, sender: AnyObject? ) {
		if segue.identifier == "showPostAttack" {
			if let destination = segue.destinationViewController as? PostAttackViewController {
				destination.causeOfAttack = causeOfAttackTextView.text

				// + 1 to account for 0 index
				destination.attackSeverity = severityRatingPicker.selectedRowInComponent( 0 ) + 1
			}
		}
	}

}
