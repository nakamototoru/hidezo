//
//  HDZTopViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/19/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZTopViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.		
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if HDZUserDefaults.login {
            // is login
            let controller: HDZHomeViewController = HDZHomeViewController.createViewController()
            UIApplication.setRootViewController(viewController: controller)
        } else {
            // not login
            let controller: UINavigationController = HDZLoginViewController.createViewController()
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
}

extension HDZTopViewController {
    
    internal class func createViewController() -> HDZTopViewController {
        return UIViewController.createViewController(name: "HDZTopViewController")
    }
}
