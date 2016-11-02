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

class HDZCommentFormViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendCommentButton: UIButton!

    private var order_no: String = ""
    private var messageResult: MessageResult! = nil

    private var request: Alamofire.Request? = nil
    private var listCharger:[String] = []
    private var charge: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // ボタン装飾
        self.sendCommentButton.layer.cornerRadius = 5.0

        // テキストビュー装飾
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // アクション送信
    @IBAction func didSelectedSend(sender: AnyObject) {
        
        guard let message: String = self.commentTextView.text else {
            self.sendCommentButton.enabled = true
            return
        }
        
        let completion: (unboxable: MessageAddResult?) -> Void = { (unboxable) in
            self.request = nil
            //            self.delegate?.requestUpdate()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let error: (error: ErrorType?, unboxable: MessageAddError?) -> Void = { (error, unboxable) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.request = HDZApi.adMessage(self.order_no, charge: self.charge, message: message, completionBlock: completion, errorBlock: error)
        
        self.sendCommentButton.enabled = false
    }

    // アクション閉じる
    @IBAction func onCloseSelf(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //        return self.chargeList.count
        return self.listCharger.count
    }
}

// MARK: - UIPickerViewDelegate
extension HDZCommentFormViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.charge = self.listCharger[row]
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.listCharger[row]
    }
}
