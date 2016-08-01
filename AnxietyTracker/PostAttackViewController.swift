//
//  PostAttackViewController.swift
//  AnxietyTracker
//
//  Created by Ryan Walsh on 7/29/16.
//  Copyright © 2016 Ryan Walsh. All rights reserved.
//

import UIKit

class PostAttackViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {

	@IBOutlet weak var retrospectSeverityPicker: UIPickerView!
	@IBOutlet weak var howDidAttackPassTextView: UITextView!

	var causeOfAttack: String = ""
	var attackSeverity: Int = 0

	override func viewDidLoad() {
		super.viewDidLoad()

		howDidAttackPassTextView.addBorder()
		howDidAttackPassTextView.delegate = self

		retrospectSeverityPicker.delegate = self
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
		return "\( row + 1 )"
	}

	// MARK: - Actions
	@IBAction func savePostAttackButtonPressed( sender: UIButton ) {
		AttackController.sharedController.createAttack( attackSeverity, postAttackSeverity: retrospectSeverityPicker.selectedRowInComponent( 0 ) + 1, causeOfAttack: causeOfAttack, managedAttackBy: howDidAttackPassTextView.text )
		performSegueWithIdentifier( "unwindToHome", sender: nil )
	}


}
