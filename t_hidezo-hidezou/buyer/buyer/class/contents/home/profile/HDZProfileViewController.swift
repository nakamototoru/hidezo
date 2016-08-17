//
//  HDZProfileViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZProfileViewController: UITableViewController {

    @IBOutlet weak var addressCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var mobileCell: UITableViewCell!
    @IBOutlet weak var telCell: UITableViewCell!
    @IBOutlet weak var ownerCell: UITableViewCell!
	@IBOutlet weak var nameCell: UITableViewCell!

    private var request: Alamofire.Request? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.me()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.request == nil {
            self.me()
        }
        
        self.request?.resume()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.request?.suspend()
    }
    
    deinit {
        self.request?.cancel()
    }
}

// MARK: - action
extension HDZProfileViewController {
    
    @IBAction func didSelectedLogout(sender: UIBarButtonItem) {
     
        let handler: (UIAlertAction) -> Void = { (alertAction: UIAlertAction) in
            HDZUserDefaults.login = false
            HDZUserDefaults.id = 0
            
            let controller: HDZTopViewController = HDZTopViewController.createViewController()
            UIApplication.setRootViewController(controller)
            
            let navigationController: UINavigationController = HDZLoginViewController.createViewController()
            self.presentViewController(navigationController, animated: true, completion: {
                self.tabBarController?.selectedIndex = 0
            })
        }
        
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .Destructive, handler: handler)
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let controller: UIAlertController = UIAlertController(title: "ログアウトしますか？", message: "別のアカウントや現在のアカウントで再ログインすることができます。", preferredStyle: .Alert)
        controller.addAction(action)
        controller.addAction(cancel)
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
}

extension HDZProfileViewController {
    
    private func me() {
        
        let completion: (unboxable: MeResult?) -> Void = { (unboxable) in
            guard let result: MeResult = unboxable else {
                return
            }
            
            self.request = nil
            
            self.addressCell.textLabel?.text = result.address
            self.emailCell.textLabel?.text = result.mail_address
            self.mobileCell.textLabel?.text = result.mobile
            self.telCell.textLabel?.text = result.tel
            self.ownerCell.textLabel?.text = result.minister
			
			// !!!:デザミ
			self.nameCell.textLabel?.text = result.name;
            
            self.tableView.reloadData()
        }
        
        let error: (error: ErrorType?, result: MeError?) -> Void = { (error, result) in
            
        }
        
        self.request = HDZApi.me(completion, errorBlock: error)
    }
}
