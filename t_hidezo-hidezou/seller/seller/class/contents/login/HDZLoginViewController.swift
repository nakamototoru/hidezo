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
        super.viewDidDisappear(animated)
        
        self.loginRequest?.resume()
        self.loginCheckRequest?.resume()
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
    
    @IBAction func didSelectedLoginWithButton(button: UIButton) {
        
        guard let idString: String = self.idTextField.text else {
            return
        }
        
        guard let id: Int = Int(idString) else {
            return
        }
        
        guard let password: String = self.passwordTextField.text else {
            return
        }
        
        self.loginCheck(id, password: password)
    }
}

// MARK: - private
extension HDZLoginViewController {
    
    private func loginCheck(id: Int, password: String) {
        
        let completion: (unboxable: LoginCheckResult?) -> Void = { (unboxable) in
            
            guard let result: LoginCheckResult = unboxable else {
                return
            }
            
            debugPrint(result)
            
            self.loginCheckRequest = nil
            
            self.login(id, password: password)
        }
        
        let error: (error: ErrorType?, result: LoginCheckError?) -> Void = { (error, result) in
            debugPrint(error)
            debugPrint(result)
            
            let action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            let controller: UIAlertController = UIAlertController(title: "ログインエラー", message: "パスワードまたはIDが一致しません", preferredStyle: UIAlertControllerStyle.Alert)
            controller.addAction(action)
            
            self.presentViewController(controller, animated: true, completion: nil)

        }
        
        self.loginCheckRequest = HDZApi.loginCheck(id, password: password, completionBlock: completion, errorBlock: error)
    }
    
    private func login(id: Int, password: String) {
     
        let completion: (unboxable: LoginResult?) -> Void = { (unboxable) in
            
            guard let result: LoginResult = unboxable else {
                return
            }
            
            debugPrint(result)
            
            self.loginRequest = nil
            
            if result.result {
                // login success
                HDZUserDefaults.login = true
                HDZUserDefaults.id = id
                
                self.dismissViewControllerAnimated(true, completion: {
                    let controller: HDZHomeViewController = HDZHomeViewController.createViewController()
                    UIApplication.setRootViewController(controller)
                })
            } else {
                // login error
                HDZUserDefaults.login = false

                let action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                let controller: UIAlertController = UIAlertController(title: "ログインエラー", message: result.message, preferredStyle: UIAlertControllerStyle.Alert)
                controller.addAction(action)
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
            
        }
        
        let error: (error: ErrorType?, result: LoginResult?) -> Void = { (error, result) in

            debugPrint(error)
            debugPrint(result)

            HDZUserDefaults.login = false
            
            let action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            let controller: UIAlertController = UIAlertController(title: "ログインエラー", message: "パスワードまたはIDが一致しません", preferredStyle: UIAlertControllerStyle.Alert)
            controller.addAction(action)
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
        self.loginRequest = HDZApi.login(id, password: password, completionBlock: completion, errorBlock: error)
    }
}
