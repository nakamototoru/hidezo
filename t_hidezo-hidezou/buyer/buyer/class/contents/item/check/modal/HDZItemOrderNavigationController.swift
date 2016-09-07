//
//  HDZItemOrderNavigationController.swift
//  buyer
//
//  Created by デザミ on 2016/08/19.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemOrderNavigationController: UINavigationController {

	var supplierId: String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// ルートビューに値を渡す
//		let rootviewcontroller = self.viewControllers.first;
//		if ((rootviewcontroller) != nil) {
//			let vc = rootviewcontroller as! HDZItemOrderDialogViewController
//			vc.supplierId = self.supplierId
//		}

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

//extension HDZItemOrderNavigationController {
//	
//	internal class func createViewController() -> HDZItemOrderNavigationController {
//		let controller: HDZItemOrderNavigationController = UIViewController.createViewController("HDZItemOrderDialogViewController", withIdentifier: "HDZItemOrderNavigationController")
//		//controller.friendInfo = friendInfo
//		return controller
//	}
//}
