//
//  HDZCommentFormViewController.swift
//  buyer
//
//  Created by 庄俊亮 on 2016/11/01.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import Unbox

// , UIPickerViewDelegate, UIPickerViewDataSource
class HDZCommentFormViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendCommentButton: UIButton!

	var order_no: String = ""
	var messageResult: MessageResult! = nil

	var request: Alamofire.Request? = nil
	var listCharger:[String] = []
	var charge: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // ボタン装飾
        self.sendCommentButton.layer.cornerRadius = 5.0

        // テキストビュー装飾
        self.commentTextView.layer.cornerRadius = 5.0
        self.commentTextView.layer.borderWidth = 1.0
        self.commentTextView.layer.borderColor = UIColor.gray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.request?.resume()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.request?.suspend()
    }
    
    deinit {
        self.request?.cancel()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // アクション送信
    @IBAction func didSelectedSend(_ sender: Any) {
        
        guard let message: String = self.commentTextView.text else {
            self.sendCommentButton.isEnabled = true
            return
        }
        
        let completion: (_ unboxable: MessageAddResult?) -> Void = { (unboxable) in
            self.request = nil
            //            self.delegate?.requestUpdate()
            self.dismiss(animated: true, completion: nil)
        }
        
        let error: (_ error: Error?, _ unboxable: MessageAddError?) -> Void = { (error, unboxable) in
            self.dismiss(animated: true, completion: nil)
        }
        
        self.request = HDZApi.adMessage(order_no: self.order_no, charge: self.charge, message: message, completionBlock: completion, errorBlock: error)
        
        self.sendCommentButton.isEnabled = false
    }

    // アクション閉じる
    @IBAction func onCloseSelf(_ sender: Any) {
        
        self.dismiss(animated: true) { 
            
        }
    }
	
	// MARK: - UIPickerViewDataSource
//	func numberOfComponents(in pickerView: UIPickerView) -> Int {
//		return 1
//	}
//	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//		//        return self.chargeList.count
//		return self.listCharger.count
//	}
//	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//		return self.listCharger[row]
//	}
//
//	// MARK: - UIPickerViewDelegate
//	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//		self.charge = self.listCharger[row]
//	}

}

extension HDZCommentFormViewController {
    
    internal func setupMessage(messageResult:MessageResult, order_no:String) {
        self.messageResult = messageResult
        self.order_no = order_no
        
        self.listCharger = self.messageResult.chargeList
        self.charge = self.listCharger[0]
    }
}

// MARK: - UIPickerViewDataSource
extension HDZCommentFormViewController: UIPickerViewDataSource {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
    //func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.listCharger.count
    }
}

// MARK: - UIPickerViewDelegate
extension HDZCommentFormViewController: UIPickerViewDelegate {
	
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.charge = self.listCharger[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listCharger[row]
    }
}
