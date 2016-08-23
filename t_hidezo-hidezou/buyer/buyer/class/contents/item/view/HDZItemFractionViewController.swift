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
	var parent:UIViewController!
	
	private var strSelected:String! = "0"
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	override func viewWillAppear(animated: Bool) {
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
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - staic
extension HDZItemFractionViewController {
	
	internal class func createViewController(parent:UIViewController, fractions: [String], itemsize: String) -> HDZItemFractionViewController {
		let controller: HDZItemFractionViewController = HDZItemFractionViewController(nibName: "HDZItemFractionViewController", bundle: nil)
		//.createViewController("HDZItemFractionViewController")
		
		controller.parent = parent

		controller.arrayFraction = NSMutableArray()
		controller.arrayFraction.addObject("注文しない")
		controller.arrayFraction.addObjectsFromArray(fractions)
		
		controller.strSelected = itemsize //controller.arrayFraction[0] as! String
		
		return controller
	}
}

// MARK: - UIPickerViewDataSource
extension HDZItemFractionViewController: UIPickerViewDataSource {
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.arrayFraction.count
	}
}

// MARK: - UIPickerViewDelegate
extension HDZItemFractionViewController: UIPickerViewDelegate {
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

		if row > 0 {
			self.strSelected = self.arrayFraction[row] as! String
		}
		else {
			self.strSelected = "0"
		}
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.arrayFraction[row] as? String
	}
}

// MARK: - Selector
extension HDZItemFractionViewController {
	
	@IBAction func onCloseFraction(sender: AnyObject) {

		// 値の送信
		self.delegate?.itemfractionSelected(self.strSelected)
		
		// 自分閉じる
		self.parent.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationFade)
	}
}


