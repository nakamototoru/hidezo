//
//  HDZItemCategoryNavigationController.swift
//  buyer
//
//  Created by デザミ on 2016/08/15.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemCategoryNavigationController: UINavigationController {

	private var friendInfo: FriendInfo! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let rootviewcontroller = self.viewControllers.first;
		if ((rootviewcontroller) != nil) {
			let vc = rootviewcontroller as! HDZItemCategoryTableViewController
			vc.setupFriendInfo(self.friendInfo)
		}
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

extension HDZItemCategoryNavigationController {
	
	internal class func createViewController(friendInfo: FriendInfo) -> HDZItemCategoryNavigationController {
		let controller: HDZItemCategoryNavigationController = UIViewController.createViewController("HDZItemCategoryTableViewController", withIdentifier: "HDZItemCategoryNavigationController")
		controller.friendInfo = friendInfo
		return controller
	}
}
