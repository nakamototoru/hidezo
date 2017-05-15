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
	@IBOutlet weak var labelDebugPrint: UILabel!
    
	var loginRequest: Alamofire.Request? = nil
	var loginCheckRequest: Alamofire.Request? = nil
	
	// !!!:dezami
	var deviceTokenRequest: Alamofire.Request? = nil

	internal class func createViewController() -> UINavigationController {
		return UINavigationController.createViewController(name: "HDZLoginViewController")
	}

	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loginButton.layer.cornerRadius = 5.0
		
		self.buttonSignup.layer.borderColor = UIColor.red.cgColor
		self.buttonSignup.layer.borderWidth = 1.0
		
		if HDZConfiguration.getIsBuildProduct() {
			labelDebugPrint.text = ""
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loginRequest?.resume()
        self.loginCheckRequest?.resume()

        self.settingIdText(notification: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.loginRequest?.suspend()
        self.loginCheckRequest?.suspend()
    }
    
    deinit {
        self.loginRequest?.cancel()
        self.loginCheckRequest?.cancel()
    }
	
	// !!!: MFMailComposeViewControllerDelegate
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		switch result.rawValue {
		case MFMailComposeResult.cancelled.rawValue:
			print("Email Send Cancelled")
			break
		case MFMailComposeResult.saved.rawValue:
			print("Email Saved as a Draft")
			break
		case MFMailComposeResult.sent.rawValue:
			print("Email Sent Successfully")
			break
		case MFMailComposeResult.failed.rawValue:
			print("Email Send Failed")
			//MyWarning.Warning(message: "送信に失敗しました")
			UIAlertController(title: "エラー", message: "送信に失敗しました", preferredStyle: .alert)
				.addAction(title: "OK", style: .default, handler: nil)
				.show()
			break
		default:
			break
		}
		self.dismiss(animated: true, completion: nil)
	}

	// MARK: - API
	func loginCheck(id: String, password: String) {
		
		let completion: (_ unboxable: LoginCheckResult?) -> Void = { (unboxable) in
			
			guard let _: LoginCheckResult = unboxable else {
				return
			}
			
			self.loginCheckRequest = nil
			
			self.login(login_id: id, password: password)
		}
		
		let error: (_ error: Error?, _ result: LoginCheckError?) -> Void = { (error, result) in
			
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			let controller: UIAlertController = UIAlertController(title: "ログインエラー", message: "パスワードまたはIDが一致しません", preferredStyle: .alert)
			controller.addAction(action)
			
			self.present(controller, animated: true, completion: nil)
			
		}
		
		self.loginCheckRequest = HDZApi.loginCheck(id: id, password: password, completionBlock: completion, errorBlock: error)
	}
	
	func login(login_id: String, password: String) {
		
		let completion: (_ unboxable: LoginResult?) -> Void = { (unboxable) in
			
			// ログイン完了
			guard let result: LoginResult = unboxable else {
				return
			}
			
			self.loginRequest = nil
			
			if result.result {
				// login success
				HDZUserDefaults.login = true
				HDZUserDefaults.login_id = login_id
				HDZUserDefaults.id = result.id
				
				self.dismiss(animated: true, completion: {
					let controller: HDZHomeViewController = HDZHomeViewController.createViewController()
					UIApplication.setRootViewController(viewController: controller)
				})
				
				DeployGateExtra.dgsLog("ログイン：" + HDZUserDefaults.id)
				
				// デバイストークン送信
				let completionToken: (_ unboxable: DeviceTokenResult?) -> Void = { (unboxable) in
					DeployGateExtra.dgsLog("ログイン時トークン送信\n HDZLoginViewController.login\n <deviceToken>: " + HDZUserDefaults.devicetoken)
				}
				let errorToken: (_ error: Error?, _ result: DeviceTokenError?) -> Void = { (error, result) in
					DeployGateExtra.dgsLog("HDZLoginViewController.login -> Failed send DeviceToken")
				}
				self.deviceTokenRequest = HDZApi.postDeviceToken(id: result.id, completionBlock: completionToken, errorBlock: errorToken)
				
			}
			else {
				// login error
				HDZUserDefaults.login = false
				
				let action: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
				let controller: UIAlertController = UIAlertController(title: "ログインエラー", message: result.message, preferredStyle: .alert)
				controller.addAction(action)
				
				self.present(controller, animated: true, completion: nil)
			}
			
		}
		
		let error: (_ error: Error?, _ result: LoginResult?) -> Void = { (error, result) in
			// login error
			HDZUserDefaults.login = false
			
			let action: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			let controller: UIAlertController = UIAlertController(title: "ログインエラー", message: "パスワードまたはIDが一致しません", preferredStyle: .alert)
			controller.addAction(action)
			
			self.present(controller, animated: true, completion: nil)
		}
		
		self.loginRequest = HDZApi.login(login_id: login_id, password: password, completionBlock: completion, errorBlock: error)
	}
	
	func settingIdText(notification: NSNotification!) {
		
		self.idTextField.text = HDZUserDefaults.login_id
		
		//        let id: Int = Int( HDZUserDefaults.id )!
		//        if id > 0 {
		//            self.idTextField.text = String(format: "%ld", id)
		//        }
	}
	
	// MARK: - Action
	@IBAction func onLoginButton(_ sender: Any) {
		
		guard let idString: String = self.idTextField.text else {
			//MyWarning.Warning(message: "IDが入力されていません")
			UIAlertController(title: "警告", message: "IDが入力されていません", preferredStyle: .alert)
				.addAction(title: "OK", style: .default, handler: nil)
				.show()
			return
		}
		if idString == "" {
			//MyWarning.Warning(message: "IDが入力されていません")
			UIAlertController(title: "警告", message: "IDが入力されていません", preferredStyle: .alert)
				.addAction(title: "OK", style: .default, handler: nil)
				.show()
			return
		}
		
		guard let password: String = self.passwordTextField.text else {
			//MyWarning.Warning(message: "パスワードが入力されていません")
			UIAlertController(title: "警告", message: "パスワードが入力されていません", preferredStyle: .alert)
				.addAction(title: "OK", style: .default, handler: nil)
				.show()
			return
		}
		if password == "" {
			//MyWarning.Warning(message: "パスワードが入力されていません")
			UIAlertController(title: "警告", message: "パスワードが入力されていません", preferredStyle: .alert)
				.addAction(title: "OK", style: .default, handler: nil)
				.show()
			return
		}
		
		self.login(login_id: idString, password: password)
	}
	
//	@IBAction func onRecoverPassword(_ sender: Any) {
//		
//		self.openMailForRequest()
//	}
//	
//	@IBAction func onSignup(_ sender: Any) {
//		
//		self.openMailForRequest()
//	}
	
//	func openMailForRequest() {
//		
//		if MFMailComposeViewController.canSendMail() {
//			let mailPicker:MFMailComposeViewController = MFMailComposeViewController()
//			mailPicker.mailComposeDelegate = self
//			
//			// 1.件名
//			mailPicker.setSubject("問い合わせ")
//			// 2.本文
//			mailPicker.setMessageBody("■会社名（お名前）：\n■お電話番号：\n■メールアドレス：\n■お問い合わせ内容：", isHTML: false)
//			// 3.送信先アドレス
//			let toRecipients = ["info@beyondfoods.jp"] //Toのアドレス指定
//			mailPicker.setToRecipients(toRecipients)
//			// 開く
//			self .present(mailPicker, animated: true, completion: {
//				
//			})
//		}
//		else {
//			//MyWarning.Warning(message: "メーラーが使用できません")
//			UIAlertController(title: "警告", message: "メーラーが使用できません", preferredStyle: .alert)
//				.addAction(title: "OK", style: .default, handler: nil)
//				.show()
//		}
//	}
	
//	@IBAction func onOpenAgreement(_ sender: Any) {
//		
//		let controller:HDZAgreementViewController = HDZAgreementViewController.createViewController()
//		self.navigationController?.pushViewController(controller, animated: true)
//	}
	
}
