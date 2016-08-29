//
//  HDZHomeViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZHomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		// !!!:・デザミシステム
		// アイコンカラー（画像）の設定
		var assets :Array<String> = ["maru", "maru", "maru"]
		for (idx, item) in self.tabBar.items!.enumerate() {
			item.image = UIImage(named: assets[idx])?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
		}
		
		// !!!:タブバーへバッジ表示
		//self.tabBarController?.tabBar.items![0].badgeValue = "3" // 下階層から呼ぶ場合

		self.tabBar.items![0].badgeValue = "3"
		self.tabBar.items![1].badgeValue = "4"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HDZHomeViewController {
    
    internal class func createViewController() -> HDZHomeViewController {
        return UIViewController.createViewController("HDZHomeViewController")
    }
}
