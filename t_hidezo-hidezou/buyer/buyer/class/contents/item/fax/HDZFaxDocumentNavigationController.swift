//
//  HDZFaxDocumentNavigationController.swift
//  buyer
//
//  Created by 庄俊亮 on 2017/01/13.
//  Copyright © 2017年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZFaxDocumentNavigationController: UINavigationController {
	
	var orderNumber = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// ルートビューに値を渡す
		let rootviewcontroller = self.viewControllers.first;
		if ((rootviewcontroller) != nil) {
			let vc = rootviewcontroller as! HDZFaxDocumentViewController
			vc.setupValue(self.orderNumber)
		}

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
extension HDZFaxDocumentNavigationController {
	
	internal class func createViewController(orderNumber:String) -> HDZFaxDocumentNavigationController {
		let controller: HDZFaxDocumentNavigationController = UIViewController.createViewController("HDZFaxDocumentViewController", withIdentifier: "HDZFaxDocumentNavigationController")
		controller.orderNumber = orderNumber
		return controller
	}
}
