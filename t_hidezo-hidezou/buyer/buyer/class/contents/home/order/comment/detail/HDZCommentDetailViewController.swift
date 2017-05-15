//
//  HDZCommentDetailViewController.swift
//  buyer
//
//  Created by デザミ on 2016/09/02.
//  Copyright © 2016年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZCommentDetailViewController: UIViewController {

	@IBOutlet weak var textviewDetail: UITextView!
	
	var textDetail:String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		textviewDetail.text = textDetail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
