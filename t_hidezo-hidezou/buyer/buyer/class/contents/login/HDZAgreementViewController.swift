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
		let path_rich:String = NSBundle.mainBundle().pathForResource("kiyaku", ofType: "rtf")!
		let url_rich:NSURL = NSURL(fileURLWithPath: path_rich)
		let request:NSURLRequest = NSURLRequest(URL: url_rich)
		webviewAgreement.loadRequest(request)
		
    }

	/*
	WebViewのloadが終了した時に呼ばれるメソッド.
	*/
	func webViewDidFinishLoad(webView: UIWebView) {
		print("load finished")

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

extension HDZAgreementViewController {
	
	internal class func createViewController() -> HDZAgreementViewController {
		let controller: HDZAgreementViewController = UIViewController.createViewController("HDZAgreementViewController")
		return controller
	}

}