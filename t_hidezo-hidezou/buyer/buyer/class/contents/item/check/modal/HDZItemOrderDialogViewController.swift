//
//  HDZItemOrderDialogViewController.swift
//  buyer
//
//  Created by デザミ on 2016/08/19.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZItemOrderDialogViewController: UIViewController {

	var supplierId: String = ""

	@IBOutlet weak var pickerviewDate: UIPickerView!
	@IBOutlet weak var pickerviewCharge: UIPickerView!
	@IBOutlet weak var pickerviewPlace: UIPickerView!
	@IBOutlet weak var textviewComment: UITextView!

	private var arrayDate:NSMutableArray!
	private var arrayCharge:NSMutableArray!
	private var arrayPlace:NSMutableArray!
	
	private var itemResult: ItemResult! = nil
	private var request: Alamofire.Request? = nil

	private var ddate:String! = ""
	private var charge:String! = ""
	private var place:String! = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		self.arrayDate = NSMutableArray()
		self.arrayDate .addObjectsFromArray(["選択なし","最短納品日","月曜日","火曜日","水曜日","木曜日","金曜日","土曜日","日曜日"])
		
		self.arrayCharge = NSMutableArray()
		
		self.arrayPlace = NSMutableArray()
		
		self.textviewComment.text = HDZItemOrderManager.shared.comment
		
//		HDZItemOrderManager.shared.deliverto = ""
//		HDZItemOrderManager.shared.charge = ""
//		HDZItemOrderManager.shared.deliverdate = ""

		// APi
		self.getItem(self.supplierId)
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

// MARK: - API
extension HDZItemOrderDialogViewController {
	
	private func getItem(supplierId: String) {
		
		let completion: (unboxable: ItemResult?) -> Void = { (unboxable) in
			
			self.request = nil
			
			guard let result: ItemResult = unboxable else {
				return
			}
			
			self.itemResult = result
			
			#if DEBUG
			let supid:String = String(self.itemResult.supplier.supplier_id)
			let supname:String = self.itemResult.supplier.supplier_name
			debugPrint(supid + ":" + supname)
			#endif
			
			// 担当者一覧
			let charges:NSArray = self.itemResult.charge_list
			self.arrayCharge.removeAllObjects()
			self.arrayCharge.addObject("選択なし")
			self.arrayCharge.addObjectsFromArray(charges as! [String])
			
			// 配達先一覧
			let places:NSArray = self.itemResult.deliver_to_list
			self.arrayPlace.removeAllObjects()
			self.arrayPlace.addObject("選択なし")
			self.arrayPlace.addObjectsFromArray(places as! [String])
			
			// ピッカー更新
			self.pickerviewCharge.reloadAllComponents()
			self.pickerviewPlace.reloadAllComponents()
			
			//ピッカー位置
			var count:Int = 0;
			for str in self.arrayDate {
				if HDZItemOrderManager.shared.deliverdate == str as! String {
					self.ddate = str as! String
					self.pickerviewDate.selectRow(count, inComponent: 0, animated: false)
					break;
				}
				count += 1
			}
			
			count = 0
			for str in self.arrayCharge {
				if HDZItemOrderManager.shared.charge == str as! String {
					self.charge = str as! String
					self.pickerviewCharge.selectRow(count, inComponent: 0, animated: false)
					break;
				}
				count += 1
			}
			
			count = 0
			for str in self.arrayPlace {
				if HDZItemOrderManager.shared.deliverto == str as! String {
					self.place = str as! String
					self.pickerviewPlace.selectRow(count, inComponent: 0, animated: false)
					break;
				}
				count += 1
			}
			// end
		}
		
		let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
			
//			NSLog("HDZItemOrderDialogViewController.getItem")
//			NSLog("\(error.debugDescription)")
			
			self.request = nil
		}
		
//		let userid:String = String(supplierId)
//		debugPrint(userid)

		self.request = HDZApi.item(supplierId, completionBlock: completion, errorBlock: error)
	}
}

extension HDZItemOrderDialogViewController {
	
	@IBAction func onCloseDialog(sender: AnyObject) {
		
		self.dismissViewControllerAnimated(true) {
			
		}
	}
	
	@IBAction func onSaveDialog(sender: AnyObject) {
		
		HDZItemOrderManager.shared.deliverto = self.place
		HDZItemOrderManager.shared.charge = self.charge
		HDZItemOrderManager.shared.deliverdate = self.ddate
		HDZItemOrderManager.shared.comment = self.textviewComment.text
		
		self.dismissViewControllerAnimated(true) {
			
		}
	}
	
}

// MARK: - UIPickerViewDataSource
extension HDZItemOrderDialogViewController: UIPickerViewDataSource {
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		if pickerView == self.pickerviewDate {
			return self.arrayDate.count
		}
		if pickerView == self.pickerviewCharge {
			return self.arrayCharge.count
		}
		if pickerView == self.pickerviewPlace {
			return self.arrayPlace.count
		}
		
		return 1 //self.chargeList.count
	}
}

// MARK: - UIPickerViewDelegate
extension HDZItemOrderDialogViewController: UIPickerViewDelegate {
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		if pickerView == self.pickerviewDate {
			if row >= 1 {
				self.ddate = self.arrayDate[row] as! String
			}
			else {
				self.ddate = ""
			}
		}
		else if pickerView == self.pickerviewCharge {
			if row >= 1 {
				self.charge = self.arrayCharge[row] as! String
			}
			else {
				self.charge = ""
			}
		}
		else if pickerView == self.pickerviewPlace {
			if row >= 1 {
				self.place = self.arrayPlace[row] as! String
			}
			else {
				self.place = ""
			}
		}
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if pickerView == self.pickerviewDate {
			return self.arrayDate[row] as? String
		}
		if pickerView == self.pickerviewCharge {
			return self.arrayCharge[row] as? String
		}
		if pickerView == self.pickerviewPlace {
			return self.arrayPlace[row] as? String
		}

		return "aaa" //self.chargeList[row]
	}
	
}
