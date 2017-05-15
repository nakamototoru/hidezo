//
//  UIPlaceHolderTextView.swift
//  buyer
//
//  Created by デザミ on 2016/09/01.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class UIPlaceHolderTextView: UITextView {

	lazy var placeHolderLabel:UILabel = UILabel()
	var placeHolderColor:UIColor = UIColor.lightGray
	var placeHolder:String = ""
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		// UITextViewTextDidChangeNotification
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(UIPlaceHolderTextView.textChanged),
		                                       name: Notification.Name.UITextViewTextDidChange,
		                                       object: nil)
	}
	
	func updateText(text:String) {
		super.text = text
		self.textChanged(notification: nil)
	}
	
	func updatePlaceHolder(holder:String) {
		self.placeHolder = holder
		self.textChanged(notification: nil)
	}
	
	override func draw(_ rect: CGRect) {
	//override func drawRect(rect: CGRect) {
		if(self.placeHolder != "") {
			self.placeHolderLabel.frame           = CGRect(x:8, y:8, width:self.bounds.size.width - 16, height: 0)
			self.placeHolderLabel.lineBreakMode   = NSLineBreakMode.byWordWrapping
			self.placeHolderLabel.numberOfLines   = 0
			self.placeHolderLabel.font            = self.font
			self.placeHolderLabel.backgroundColor = UIColor.clear
			self.placeHolderLabel.textColor       = self.placeHolderColor
			self.placeHolderLabel.alpha           = 0
			self.placeHolderLabel.tag             = 999
			
			self.placeHolderLabel.text = self.placeHolder
			self.placeHolderLabel.sizeToFit()
			self.addSubview(placeHolderLabel)
		}
		
		self.sendSubview(toBack: placeHolderLabel)
		
		if(self.text == "" && self.placeHolder != ""){
			self.viewWithTag(999)?.alpha = 1
		}
		
		super.draw(rect)
	}
	
	func textChanged(notification:NSNotification?) -> (Void) {
		if(self.placeHolder == ""){
			return
		}
		
		if(self.text == "") {
			self.viewWithTag(999)?.alpha = 1
		}else{
			self.viewWithTag(999)?.alpha = 0
		}
	}

}

extension UIPlaceHolderTextView {
	
	
}
