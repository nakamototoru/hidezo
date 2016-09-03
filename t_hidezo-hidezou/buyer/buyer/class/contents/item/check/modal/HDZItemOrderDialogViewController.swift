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
	@IBOutlet weak var textviewComment: UIPlaceHolderTextView!

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
		self.arrayDate.addObjectsFromArray(HDZItemOrderManager.shared.getListDate())
		
		self.arrayCharge = NSMutableArray()
		
		self.arrayPlace = NSMutableArray()
		
		self.textviewComment.text = HDZItemOrderManager.shared.comment
		self.textviewComment.layer.cornerRadius = 5.0
		self.textviewComment.layer.borderWidth = 1.0
		self.textviewComment.layer.borderColor = UIColor.grayColor().CGColor
		self.textviewComment.placeHolder = "コメント"

		// APi
		self.getItem(self.supplierId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
			
			// Picekr init
			// 担当者一覧
			let charges:NSArray = self.itemResult.charge_list
			self.arrayCharge.removeAllObjects()
			self.arrayCharge.addObjectsFromArray(charges as! [String])
			self.charge = self.arrayCharge[0] as! String
			
			// 配達先一覧（任意）
			let places:NSArray = self.itemResult.deliver_to_list
			self.arrayPlace.removeAllObjects()
			self.arrayPlace.addObject("選択なし")
			self.arrayPlace.addObjectsFromArray(places as! [String])
			self.place = self.arrayPlace[0] as! String
			
			// ピッカー更新
			self.pickerviewCharge.reloadAllComponents()
			self.pickerviewPlace.reloadAllComponents()
			
			//ピッカー位置
			var count:Int = 0;
			self.ddate = self.arrayDate[0] as! String
			self.pickerviewDate.selectRow(0, inComponent: 0, animated: false)
			for str in self.arrayDate {
				if HDZItemOrderManager.shared.deliverdate == str as! String {
					self.ddate = str as! String
					self.pickerviewDate.selectRow(count, inComponent: 0, animated: false)
					break;
				}
				count += 1
			}
			
			count = 0
			self.charge = self.arrayCharge[0] as! String
			self.pickerviewCharge.selectRow(0, inComponent: 0, animated: false)
			for str in self.arrayCharge {
				if HDZItemOrderManager.shared.charge == str as! String {
					self.charge = str as! String
					self.pickerviewCharge.selectRow(count, inComponent: 0, animated: false)
					break;
				}
				count += 1
			}
			
			count = 0
			self.place = self.arrayPlace[0] as! String
			self.pickerviewPlace.selectRow(0, inComponent: 0, animated: false)
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

			self.request = nil
		}

		self.request = HDZApi.item(supplierId, completionBlock: completion, errorBlock: error)
	}
}

extension HDZItemOrderDialogViewController {
	
	@IBAction func onCloseDialog(sender: AnyObject) {
		
		self.dismissViewControllerAnimated(true) {
		}
	}
	
	@IBAction func onSaveDialog(sender: AnyObject) {
		
		if self.place != "" {
			HDZItemOrderManager.shared.deliverto = self.place
		}
		else {
			HDZItemOrderManager.shared.deliverto = self.arrayPlace[0] as! String
		}
		
		if self.charge != "" {
			HDZItemOrderManager.shared.charge = self.charge
		}
		else {
			HDZItemOrderManager.shared.charge = self.arrayCharge[0] as! String
		}
		
		if self.ddate != "" {
			HDZItemOrderManager.shared.deliverdate = self.ddate
		}
		else {
			HDZItemOrderManager.shared.deliverdate = self.arrayDate[0] as! String
		}
		HDZItemOrderManager.shared.comment = self.textviewComment.text
		
		self.dismissViewControllerAnimated(true) {
		}
	}
	
}

// MARK: - UITextViewDelegate
extension HDZItemOrderDialogViewController: UITextViewDelegate {
	
	func textViewDidChange(textView: UITextView) {
		
		self.textviewComment.textChanged(nil)
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
			// 必須
			self.ddate = self.arrayDate[row] as! String
		}
		else if pickerView == self.pickerviewCharge {
			// 必須
			self.charge = self.arrayCharge[row] as! String
		}
		else if pickerView == self.pickerviewPlace {
			if row >= 1 {
				// 任意
				self.place = self.arrayPlace[row] as! String
			}
			else {
				// 空白
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
