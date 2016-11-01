//
//  HDZCommentFormViewController.swift
//  buyer
//
//  Created by 庄俊亮 on 2016/11/01.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZCommentFormViewController: UIViewController {

    private var order_no: String! = ""
    private var messageResult: MessageResult! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onCloseSelf(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}

extension HDZCommentFormViewController {
    
    internal func setupMessage(messageResult:MessageResult, order_no:String) {
        self.messageResult = messageResult
        self.order_no = order_no
    }
}
