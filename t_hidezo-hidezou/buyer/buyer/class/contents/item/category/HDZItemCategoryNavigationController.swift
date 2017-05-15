//
//  HDZItemCategoryNavigationController.swift
//  buyer
//
//  Created by デザミ on 2016/08/15.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZItemCategoryNavigationController: UINavigationController, UIViewControllerTransitioningDelegate {

//	@IBOutlet weak var toolbarNavi: UIToolbar!
	
	var friendInfo: FriendInfo! = nil
	
	let kAnimator = VcAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// ルートビューに値を渡す
		let rootviewcontroller = self.viewControllers.first;
		if ((rootviewcontroller) != nil) {
			let vc = rootviewcontroller as! HDZItemCategoryTableViewController
			vc.setupFriendInfo(friendInfo: self.friendInfo)
		}
		
		self.transitioningDelegate = self // delegateにselfを設定
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	// MARK: - UIViewControllerTransitioningDelegate
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		// この画面に遷移してくるときに呼ばれるメソッド
		kAnimator.presenting = true // 遷移してくるときにtrueにする
		return kAnimator
	}
	
	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		// この画面から遷移元に戻るときに呼ばれるメソッド
		kAnimator.presenting = false // 遷移元に戻るときにfalseにする
		return kAnimator
	}

}

// MARK: - Create
extension HDZItemCategoryNavigationController {
	
	internal class func createViewController(friendInfo: FriendInfo) -> HDZItemCategoryNavigationController {
		let controller: HDZItemCategoryNavigationController = UIViewController.createViewController(name: "HDZItemCategoryTableViewController", withIdentifier: "HDZItemCategoryNavigationController")
		controller.friendInfo = friendInfo
		return controller
	}
}
