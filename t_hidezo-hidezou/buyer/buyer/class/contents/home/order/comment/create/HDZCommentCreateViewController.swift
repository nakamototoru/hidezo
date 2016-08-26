//
//  HDZCommentCreateViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/26/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

protocol HDZCommentCreateViewControllerDelegate: NSObjectProtocol {
    func requestUpdate()
}

class HDZCommentCreateViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendCommentButton: UIButton!

    private var order_no: String! = nil
    private var messageResult: MessageResult! = nil
//    private lazy var chargeList: [String] = []

	// !!!: dezami
	private var listCharger:NSMutableArray!
	
    private var charge: String! = nil
    private var request: Alamofire.Request? = nil
    private weak var delegate: HDZCommentCreateViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ピッカー
//        if self.chargeList.count > 0 {
//            self.pickerView.selectRow(0, inComponent: 0, animated: true)
//            self.charge = self.chargeList[0]
//        }
		self.charge = ""

        self.sendCommentButton.layer.cornerRadius = 5.0
        
        self.commentTextView.layer.cornerRadius = 5.0
        self.commentTextView.layer.borderWidth = 1.0
        self.commentTextView.layer.borderColor = UIColor.grayColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.request?.resume()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.request?.suspend()
    }
    
    deinit {
        self.request?.cancel()
    }
}

// MARK: - staic
extension HDZCommentCreateViewController {
    
    internal class func createViewController(viewController: HDZCommentTableViewController, messageResult: MessageResult, order_no: String) -> HDZCommentCreateViewController {
        let controller: HDZCommentCreateViewController = UIViewController.createViewController("HDZCommentCreateViewController")
        
        controller.order_no = order_no
        controller.messageResult = messageResult
//        controller.chargeList = messageResult.chargeList
        controller.delegate = viewController
		
		// !!!:dezami
		controller.listCharger = NSMutableArray()
		controller.listCharger.addObject("選択しない")
		controller.listCharger.addObjectsFromArray(messageResult.chargeList)
		
        let size: CGSize = UIScreen.mainScreen().bounds.size
        controller.preferredContentSize = CGSize(width: size.width, height: 266.0)
        controller.modalPresentationStyle = .Popover
        
        if let presentationController = controller.popoverPresentationController {
            presentationController.permittedArrowDirections = [.Up]
            
            if let bar: UINavigationBar = viewController.navigationController?.navigationBar {
                presentationController.sourceView = bar
            }
            
            if let bounds: CGRect = viewController.navigationController?.navigationBar.bounds {
                presentationController.sourceRect = bounds
            }
            presentationController.delegate = viewController
            presentationController.backgroundColor = UIColor.lightGrayColor()
        }
        
        return controller
    }
}

// MARK: - UIPickerViewDelegate
extension HDZCommentCreateViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.charge = self.chargeList[row]
		
		if (row == 0) {
			self.charge = ""
		}
		else {
			self.charge = self.listCharger[row] as! String
		}
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return self.chargeList[row]
		return self.listCharger[row] as? String
    }

}

// MARK: - UIPickerViewDataSource
extension HDZCommentCreateViewController: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return self.chargeList.count
		return self.listCharger.count
    }
}

// MARK: - action
extension HDZCommentCreateViewController {
    
    @IBAction func didSelectedSend(sender: AnyObject) {
        
//        if self.charge == nil {
//            
//            let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//            let controller: UIAlertController = UIAlertController(title: "担当者が選択されていません。", message: nil, preferredStyle: .Alert)
//            controller.addAction(action)
//            self.presentViewController(controller, animated: true, completion: nil)
//            
//			self.sendCommentButton.enabled = true
//			
//            return
//        }
		
        guard let message: String = self.commentTextView.text else {
			self.sendCommentButton.enabled = true
            return
        }
        
        let completion: (unboxable: MessageAddResult?) -> Void = { (unboxable) in
            self.request = nil
            self.delegate?.requestUpdate()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let error: (error: ErrorType?, unboxable: MessageAddError?) -> Void = { (error, unboxable) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.request = HDZApi.adMessage(self.order_no, charge: self.charge, message: message, completionBlock: completion, errorBlock: error)
		
		self.sendCommentButton.enabled = false
    }
}
