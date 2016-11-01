//
//  HDZCommentFormNavigation.swift
//  buyer
//
//  Created by 庄俊亮 on 2016/11/01.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZCommentFormNavigation: UINavigationController,UIViewControllerTransitioningDelegate {

    private var order_no: String! = ""
    private var messageResult: MessageResult! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // ルートビューに値を渡す
        let rootviewcontroller = self.viewControllers.first;
        if ((rootviewcontroller) != nil) {
            let vc = rootviewcontroller as! HDZCommentFormViewController
            vc.setupMessage(messageResult, order_no: order_no)
        }
        
        self.transitioningDelegate = self // delegateにselfを設定
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

}

// MARK: - Create
extension HDZCommentFormNavigation {
    
    internal class func createViewController(messageResult: MessageResult, order_no: String) -> HDZCommentFormNavigation {
        let controller: HDZCommentFormNavigation = UIViewController.createViewController("HDZCommentForm", withIdentifier: "HDZCommentFormNavigation")
        controller.messageResult = messageResult
        controller.order_no = order_no
        return controller
    }
}
