//
//  HDZLoginViewController.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

class HDZLoginViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var buttonSignup: UIButton!
    
    private var loginRequest: Alamofire.Request? = nil
    private var loginCheckRequest: Alamofire.Request? = nil
	
	// !!!:dezami
	private var deviceTokenRequest: Alamofire.Request? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loginButton.layer.cornerRadius = 5.0
		
		self.buttonSignup.layer.borderColor = UIColor.redColor().CGColor
		self.buttonSignup.layer.borderWidth = 1.0
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
	
	// !!!: MFMailComposeViewControllerDelegate
	func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
		switch result.rawValue {
		case MFMailComposeResult.Cancelled.rawValue:
			print("Email Send Cancelled")
			break
		case MFMailComposeResult.Saved.rawValue:
			print("Email Saved as a Draft")
			break
		case MFMailComposeResult.Sent.rawValue:
			print("Email Sent Successfully")
			break
		case MFMailComposeResult.Failed.rawValue:
			print("Email Send Failed")
			UIWarning.Warning("送信に失敗しました")
			break
		default:
			break
		}

		self.dismissViewControllerAnimated(true, completion: nil)
	}

}

// MARK: - Create
extension HDZLoginViewController {
    
    internal class func createViewController() -> UINavigationController {
        return UINavigationController.createViewController("HDZLoginViewController")
    }
}

// MARK: - Action
extension HDZLoginViewController {
    
    @IBAction func didSelectedLogin(button: UIButton) {
        
        guard let idString: String = self.idTextField.text else {
			
			UIWarning.Warning("IDが入力されていません")
            return
        }
		
        guard let password: String = self.passwordTextField.text else {
			
			UIWarning.Warning("パスワードが入力されていません")
            return
        }
        
//        self.loginCheck(idString, password: password)
		self.login(idString, password: password)
    }
	
	@IBAction func onRecoverPassword(sender: AnyObject) {
		
		self.openMailForRequest()
	}
	
	@IBAction func onSignup(sender: AnyObject) {
		
		self.openMailForRequest()
	}
	
	private func openMailForRequest() {

		if MFMailComposeViewController.canSendMail() {
			let mailPicker:MFMailComposeViewController = MFMailComposeViewController()
			mailPicker.mailComposeDelegate = self
	
			// 1.件名
			mailPicker.setSubject("問い合わせ")
			// 2.本文
			mailPicker.setMessageBody("■会社名（お名前）：\n■お電話番号：\n■メールアドレス：\n■お問い合わせ内容：", isHTML: false)
			// 3.送信先アドレス
			let toRecipients = ["info@beyondfoods.jp"] //Toのアドレス指定
			mailPicker.setToRecipients(toRecipients)
			// 開く
			self .presentViewController(mailPicker, animated: true, completion: { 
				
			})
		}
		else {
			UIWarning.Warning("メーラーが使用できません")
		}
	}
	
	@IBAction func onOpenAgreement(sender: AnyObject) {
		
		let controller:HDZAgreementViewController = HDZAgreementViewController.createViewController()
		self.navigationController?.pushViewController(controller, animated: true)
	}
	
}

// MARK: - API
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
			
			// ログイン完了
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
				
				DeployGateExtra.DGSLog("ログイン：" + HDZUserDefaults.id)

				// !!!:dezami
				// Device Token Post
				#if TARGET_OS_SIMULATOR
					//トークンは送れない
				#else
				let completionToken: (unboxable: DeviceTokenResult?) -> Void = { (unboxable) in
					DeployGateExtra.DGSLog("ログイン時：HDZLoginViewController.login\n <deviceToken>: " + HDZUserDefaults.devicetoken)
				}
				let errorToken: (error: ErrorType?, result: DeviceTokenResult?) -> Void = { (error, result) in
					DeployGateExtra.DGSLog("HDZLoginViewController.login\n Failed send DeviceToken")
				}
				self.deviceTokenRequest = HDZApi.postDeviceToken(id, completionBlock: completionToken, errorBlock: errorToken)
				#endif
				
            }
			else {
                // login error
                HDZUserDefaults.login = false

                let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                let controller: UIAlertController = UIAlertController(title: "ログインエラー", message: result.message, preferredStyle: .Alert)
                controller.addAction(action)
                
                self.presentViewController(controller, animated: true, completion: nil)
            }
            
        }
        
        let error: (error: ErrorType?, result: LoginResult?) -> Void = { (error, result) in
			// login error
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
