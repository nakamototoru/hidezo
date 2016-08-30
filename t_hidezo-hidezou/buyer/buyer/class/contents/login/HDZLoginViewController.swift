//
//  HDZLoginViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

class HDZLoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var loginRequest: Alamofire.Request? = nil
    private var loginCheckRequest: Alamofire.Request? = nil
	
	// !!!:dezami
	private var deviceTokenRequest: Alamofire.Request? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loginButton.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loginRequest?.resume()
        self.loginCheckRequest?.resume()

        self.settingIdText(nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.loginRequest?.suspend()
        self.loginCheckRequest?.suspend()
    }
    
    deinit {
        self.loginRequest?.cancel()
        self.loginCheckRequest?.cancel()
    }
}

// MARK: - static
extension HDZLoginViewController {
    
    internal class func createViewController() -> UINavigationController {
        return UINavigationController.createViewController("HDZLoginViewController")
    }
}

// MARK: - action
extension HDZLoginViewController {
    
    @IBAction func didSelectedLogin(button: UIButton) {
        
        guard let idString: String = self.idTextField.text else {
			
			UIWarning.Warning("IDが入力されていません")
			
            return
        }
        
//        guard let id: Int = Int(idString) else {
//
//			UIWarning.Warning("IDフォーマットに誤りがあります。")
//
//			return
//        }
		
        guard let password: String = self.passwordTextField.text else {
			
			UIWarning.Warning("パスワードが入力されていません")

            return
        }
        
        self.loginCheck(idString, password: password)
    }
}

// MARK: - private
extension HDZLoginViewController {
    
    private func loginCheck(id: String, password: String) {
        
        let completion: (unboxable: LoginCheckResult?) -> Void = { (unboxable) in
            
            guard let _: LoginCheckResult = unboxable else {
                return
            }
            
            self.loginCheckRequest = nil
            
            self.login(id, password: password)
        }
        
        let error: (error: ErrorType?, result: LoginCheckError?) -> Void = { (error, result) in
            
            let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            let controller: UIAlertController = UIAlertController(title: "ログインエラー", message: "パスワードまたはIDが一致しません", preferredStyle: .Alert)
            controller.addAction(action)
            
            self.presentViewController(controller, animated: true, completion: nil)

        }
        
        self.loginCheckRequest = HDZApi.loginCheck(id, password: password, completionBlock: completion, errorBlock: error)
    }
    
    private func login(id: String, password: String) {
     
        let completion: (unboxable: LoginResult?) -> Void = { (unboxable) in
            
            guard let result: LoginResult = unboxable else {
                return
            }
            
            self.loginRequest = nil
            
            if result.result {
                // login success
                HDZUserDefaults.login = true
                HDZUserDefaults.id = id
				
                self.dismissViewControllerAnimated(true, completion: { 
                    let controller: HDZHomeViewController = HDZHomeViewController.createViewController()
                    UIApplication.setRootViewController(controller)
                })
				
				// !!!:dezami
				// Device Token Post
				#if TARGET_OS_SIMULATOR
					//トークンは送れない
				#else
				let completionToken: (unboxable: DeviceTokenResult?) -> Void = { (unboxable) in
					//debugPrint("****** completionToken ******")
				}
				let errorToken: (error: ErrorType?, result: DeviceTokenResult?) -> Void = { (error, result) in
					debugPrint(error)
				}
				self.deviceTokenRequest = HDZApi.postDeviceToken(id, completionBlock: completionToken, errorBlock: errorToken)
				#endif
				
            } else {
                // login error
                HDZUserDefaults.login = false

                let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                let controller: UIAlertController = UIAlertController(title: "ログインエラー", message: result.message, preferredStyle: .Alert)
                controller.addAction(action)
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
            
        }
        
        let error: (error: ErrorType?, result: LoginResult?) -> Void = { (error, result) in

            HDZUserDefaults.login = false
            
            let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            let controller: UIAlertController = UIAlertController(title: "ログインエラー", message: "パスワードまたはIDが一致しません", preferredStyle: .Alert)
            controller.addAction(action)
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
        self.loginRequest = HDZApi.login(id, password: password, completionBlock: completion, errorBlock: error)
    }
    
    private func settingIdText(notification: NSNotification!) {
		
		self.idTextField.text = HDZUserDefaults.id
		
//        let id: Int = Int( HDZUserDefaults.id )!
//        if id > 0 {
//            self.idTextField.text = String(format: "%ld", id)
//        }
    }
}
