//
//  HDZItemFractionViewController.swift
//  buyer
//
//  Created by デザミ on 2016/08/22.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

protocol HDZItemFractionViewControllerDelegate {
	func itemfractionSelected(fraction:String)
}

class HDZItemFractionViewController: UIViewController {

	@IBOutlet weak var pickerviewFraction: UIPickerView!
	
	var delegate:HDZItemFractionViewControllerDelegate?
	var arrayFraction:NSMutableArray!
	//var parent:UIViewController?
	var master: UIViewController?
	
	var strSelected:String! = "0"
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		var isfound:Bool = false
		var count:Int = 0
		for sz in self.arrayFraction {
			if self.strSelected == sz as! String {
				self.pickerviewFraction.selectRow(count, inComponent: 0, animated: false)
				isfound = true
				break
			}
			count += 1
		}
		if !isfound {
			self.strSelected = "0"
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

}

// MARK: - staic
extension HDZItemFractionViewController {
	
	internal class func createViewController(parent:UIViewController, fractions: [String], itemsize: String) -> HDZItemFractionViewController {
		let controller: HDZItemFractionViewController = HDZItemFractionViewController(nibName: "HDZItemFractionViewController", bundle: nil)
		//.createViewController("HDZItemFractionViewController")
		
		controller.master = parent

		controller.arrayFraction = NSMutableArray()
		controller.arrayFraction.add("注文しない")
		controller.arrayFraction.addObjects(from: fractions)
		
		controller.strSelected = itemsize //controller.arrayFraction[0] as! String
		
		return controller
	}
}

// MARK: - UIPickerViewDataSource
extension HDZItemFractionViewController: UIPickerViewDataSource {
	
//	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//		return 1
//	}
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
	//func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.arrayFraction.count
	}
}

// MARK: - UIPickerViewDelegate
extension HDZItemFractionViewController: UIPickerViewDelegate {
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
	//func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

		if row > 0 {
			self.strSelected = self.arrayFraction[row] as! String
		}
		else {
			self.strSelected = "0"
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
	//func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.arrayFraction[row] as? String
	}
}

// MARK: - Selector
extension HDZItemFractionViewController {
	
	@IBAction func onCloseFraction(_ sender: Any) {

		// 値の送信
		self.delegate?.itemfractionSelected(fraction: self.strSelected)
		
		// 自分閉じる
		//self.master?.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
		self.master?.dismissPopupViewControllerWithanimationType(animationType: MJPopupViewAnimation.Fade)
	}
}


