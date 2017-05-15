//
//  HDZAgreementViewController.swift
//  buyer
//
//  Created by デザミ on 2016/09/07.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZAgreementViewController: UIViewController, UIWebViewDelegate {

	@IBOutlet weak var webviewAgreement: UIWebView!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		/*
		規約ファイル読込
		*/
		let path_rich = Bundle.main.path(forResource: "kiyaku-4", ofType: "rtf")!
		let url_rich = URL(fileURLWithPath: path_rich)
		let request = URLRequest(url: url_rich)
		webviewAgreement.loadRequest(request)
    }

	/*
	WebViewのloadが終了した時に呼ばれるメソッド.
	*/
	func webViewDidFinishLoad(_ webView: UIWebView) {
		print("load finished")
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HDZAgreementViewController {
	
	internal class func createViewController() -> HDZAgreementViewController {
		let controller: HDZAgreementViewController = UIViewController.createViewController(name: "HDZAgreementViewController")
		return controller
	}

}
