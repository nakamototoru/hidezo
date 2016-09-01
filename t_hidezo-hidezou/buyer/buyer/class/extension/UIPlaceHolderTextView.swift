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
	var placeHolderColor:UIColor = UIColor.lightGrayColor()
	var placeHolder:String = ""
	
//	required public init(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//	}
	
//	override init(frame: CGRect){
//		super.init(frame: frame)
//	}
	
//	override init() {
//		super.init()
//	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIPlaceHolderTextView.textChanged(_:)), name: UITextViewTextDidChangeNotification, object: nil)
	}
	
	func updateText(text:String) {
		super.text = text
		self.textChanged(nil)
	}
	
	func updatePlaceHolder(holder:String) {
		self.placeHolder = holder
		self.textChanged(nil)
	}
	
	override func drawRect(rect: CGRect) {
		if(self.placeHolder != "") {
			self.placeHolderLabel.frame           = CGRectMake(8,8,self.bounds.size.width - 16,0)
			self.placeHolderLabel.lineBreakMode   = NSLineBreakMode.ByWordWrapping
			self.placeHolderLabel.numberOfLines   = 0
			self.placeHolderLabel.font            = self.font
			self.placeHolderLabel.backgroundColor = UIColor.clearColor()
			self.placeHolderLabel.textColor       = self.placeHolderColor
			self.placeHolderLabel.alpha           = 0
			self.placeHolderLabel.tag             = 999
			
			self.placeHolderLabel.text = self.placeHolder
			self.placeHolderLabel.sizeToFit()
			self.addSubview(placeHolderLabel)
		}
		
		self.sendSubviewToBack(placeHolderLabel)
		
		if(self.text == "" && self.placeHolder != ""){
			self.viewWithTag(999)?.alpha = 1
		}
		
		super.drawRect(rect)
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