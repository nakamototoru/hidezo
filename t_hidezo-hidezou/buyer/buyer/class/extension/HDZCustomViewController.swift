//
//  HDZCustomViewController.swift
//  buyer
//
//  Created by 庄俊亮 on 2017/01/18.
//  Copyright © 2017年 Shun Nakahara. All rights reserved.
//

import UIKit

class HDZCustomViewController: UIViewController {

	// !!!:プレゼンテーション用
	var tapLocation: CGPoint = CGPoint()
	var markView:HDZTouchMarkView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		// !!!:プレゼンテーション用
		self.markView = HDZTouchMarkView.createView()
		self.view.addSubview(self.markView)
		self.markView.hidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	// !!!:プレゼンテーション用
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		
		// タッチイベントを取得する
		let touch = touches.first
		// タップした座標を取得する
		tapLocation = touch!.locationInView(self.view)
		
		#if DEBUG
			debugPrint(tapLocation)
		#endif
		
		self.view.bringSubviewToFront(self.markView)
		self.markView.hidden = false
		self.markView.center = tapLocation
	}
//	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//		
//	}
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
		
		self.markView.hidden = true
	}

}
