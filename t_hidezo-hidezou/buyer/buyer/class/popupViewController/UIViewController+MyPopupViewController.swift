//
//  UIViewController+MyPopupViewController.swift
//  inst101
//
//  Created by 庄俊亮 on 2017/03/05.
//  Copyright © 2017年 庄俊亮. All rights reserved.
//

import UIKit

enum MJPopupViewAnimation: Int {
	case Fade
	case SlideBottomTop
//	case SlideBottomBottom
//	case SlideTopTop
	case SlideTopBottom
//	case SlideLeftLeft
	case SlideLeftRight
	case SlideRightLeft
//	case SlideRightRight
}

extension UIViewController {
	
	@nonobjc static let kPopupModalAnimationDuration = 0.35
	@nonobjc static let kMJPopupViewController = "kMJPopupViewController"
	@nonobjc static let kMJPopupBackgroundView = "kMJPopupBackgroundView"
	@nonobjc static let kMJSourceViewTag = 23941
	@nonobjc static let kMJPopupViewTag = 23942
	@nonobjc static let kMJOverlayViewTag = 23945
//	@nonobjc static let MJPopupViewDismissedKey = "MJPopupViewDismissed"
	@nonobjc static let kMJBackgroundAlpha:CGFloat = 0.75
	
	@nonobjc static var mj_popupViewController:UIViewController? = nil
	@nonobjc static var mj_popupBackgroundView:MyPopupBackgroundView? = nil
	@nonobjc static var dismissSelector:(() -> Void)? = nil
	
	// MARK: - +++Public+++
	// MARK: Open
//	func presentPopupViewController(popupViewController:UIViewController, dismissed:(() -> Void)? = nil) {
//		presentPopupViewController(popupViewController: popupViewController, animationType: MJPopupViewAnimation.Fade, dismissed: dismissed)
//	}
	func presentPopupViewController(popupViewController:UIViewController, animationType:MJPopupViewAnimation = .Fade, dismissed:(() -> Void)? = nil) {
		UIViewController.mj_popupViewController = popupViewController
		presentPopupView(popupView: popupViewController.view, animationType: animationType, dismissed: dismissed)
	}
	// MARK: Close
	func dismissPopupViewControllerWithanimationType(animationType:MJPopupViewAnimation) {
		
		let sourceView = topView()
		let popupView = sourceView.viewWithTag(UIViewController.kMJPopupViewTag)
		let overlayView = sourceView.viewWithTag(UIViewController.kMJOverlayViewTag)
		
		switch animationType.rawValue {
		case MJPopupViewAnimation.Fade.rawValue:
			fadeViewOut(popupView: popupView!, sourceView: sourceView, overlayView: overlayView!)
			break
		default:
			// TODO: スライドアニメーション
			break
		}
	}

	// MARK: PopupViewController
	func myPopupViewController() -> UIViewController {
		return objc_getAssociatedObject(self,
		                                UIViewController.kMJPopupViewController) as! UIViewController
	}
	func setMyPopupViewController(viewController: UIViewController) {
		objc_setAssociatedObject(self,
		                         UIViewController.kMJPopupViewController,
		                         viewController,
		                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
	// MARK: BackgroundView
	func myPopupBackgroundView() -> MyPopupBackgroundView {
		return objc_getAssociatedObject(self,
		                                UIViewController.kMJPopupBackgroundView) as! MyPopupBackgroundView
	}
	func setMyPopupBackgroundView(backgroundView:MyPopupBackgroundView) {
		objc_setAssociatedObject(self,
		                         UIViewController.kMJPopupBackgroundView,
		                         backgroundView,
		                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}

	// MARK: - +++View Hadling+++
	// MARK: Open
	private func presentPopupView(popupView:UIView, animationType:MJPopupViewAnimation, dismissed: (() -> Void)? = nil) {
		
		let sourceView = topView()
		sourceView.tag = UIViewController.kMJSourceViewTag
		popupView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin ,UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleRightMargin]
		popupView.tag = UIViewController.kMJPopupViewTag
		
		// check if source view controller is not in destination
		if sourceView.subviews.contains(popupView) {
			return
		}
		
		// customize popupView
		popupView.layer.shadowPath = UIBezierPath(rect: popupView.bounds).cgPath
		popupView.layer.masksToBounds = false
		popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
		popupView.layer.shadowRadius = 5
		popupView.layer.shadowOpacity = 0.5
		popupView.layer.shouldRasterize = true
		popupView.layer.rasterizationScale = UIScreen.main.scale
		
		// Add semi overlay
		let overlayView = UIView(frame: sourceView.bounds)
		overlayView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
		overlayView.tag = UIViewController.kMJOverlayViewTag
		overlayView.backgroundColor = UIColor.clear
		
		// BackgroundView
		UIViewController.mj_popupBackgroundView = MyPopupBackgroundView(frame: sourceView.bounds)
		UIViewController.mj_popupBackgroundView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
		UIViewController.mj_popupBackgroundView?.backgroundColor = UIColor.clear
		UIViewController.mj_popupBackgroundView?.alpha = 0.0
		overlayView.addSubview(UIViewController.mj_popupBackgroundView!)
		
		// Make the Background Clickable
		// 背景をタッチで自分閉じる
		let dismissButton = UIButton(type: UIButtonType.custom)
		dismissButton.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
		dismissButton.backgroundColor = UIColor.clear
		dismissButton.frame = sourceView.bounds
		overlayView.addSubview(dismissButton)
		
		popupView.alpha = 0.0
		overlayView.addSubview(popupView)
		sourceView.addSubview(overlayView)
		
		dismissButton.addTarget(self, action: #selector(dismissPopupViewControllerWithanimation(sender:)), for: UIControlEvents.touchUpInside)
		
		// Open Animation
		switch animationType.rawValue {
		case MJPopupViewAnimation.Fade.rawValue:
			dismissButton.tag = MJPopupViewAnimation.Fade.rawValue
			fadeViewIn(popupView: popupView, sourceView: sourceView, overlayView: overlayView)
			break
		default:
			dismissButton.tag = animationType.rawValue
			// TODO: スライドアニメーション
			break
		}
		
		// Callback regist
		if dismissed != nil {
			self.setDismissedCallback(dismissed: dismissed!)
		}
	}
	
	// MARK: Get BaseView
	private func topView() -> UIView {
		return (UIApplication.shared.topViewController?.view)!
	}

	// MARK: Button Action
	@objc private func dismissPopupViewControllerWithanimation(sender:UIButton?) {
		guard let dismissButton:UIButton = sender else {
			return
		}

		switch dismissButton.tag {
		case MJPopupViewAnimation.Fade.rawValue:
			dismissPopupViewControllerWithanimationType(animationType: MJPopupViewAnimation.Fade)
			break
		default:
			let type: MJPopupViewAnimation = MJPopupViewAnimation(rawValue: dismissButton.tag)!
			dismissPopupViewControllerWithanimationType(animationType: type)
			break
		}
	}
	
	// MARK: - +++Fade+++
	// MARK: In
	private func fadeViewIn(popupView:UIView, sourceView:UIView, overlayView:UIView) {
		// Generating Start and Stop Positions
		let sourceSize: CGSize = sourceView.bounds.size
		let popupSize:CGSize = popupView.bounds.size
		let popupEndRect:CGRect = CGRect(x: (sourceSize.width - popupSize.width) / 2,
		                                 y: (sourceSize.height - popupSize.height) / 2,
		                                 width: popupSize.width,
		                                 height: popupSize.height)
		
		// Set starting properties
		popupView.frame = popupEndRect
		popupView.alpha = 0.0
		
		// Animation
		UIView.animate(withDuration: UIViewController.kPopupModalAnimationDuration, animations: {
			UIViewController.mj_popupViewController?.viewWillAppear(false)
			UIViewController.mj_popupBackgroundView?.alpha = UIViewController.kMJBackgroundAlpha
			popupView.alpha = 1.0
		}) { (Bool) in
			UIViewController.mj_popupViewController?.viewDidAppear(false)
		}
	}
	// MARK: Out
	private func fadeViewOut(popupView:UIView, sourceView:UIView, overlayView:UIView) {
		
		// Animation
		UIView.animate(withDuration: UIViewController.kPopupModalAnimationDuration, animations: {
			UIViewController.mj_popupViewController?.viewWillDisappear(false)
			UIViewController.mj_popupBackgroundView?.alpha = 0.0
			popupView.alpha = 0.0
		}) { (Bool) in
//			popupView.removeFromSuperview()
//			overlayView.removeFromSuperview()
//			UIViewController.mj_popupViewController?.viewDidDisappear(false)
//			UIViewController.mj_popupViewController = nil
//			
//			if let dismissed = self.dismissedCallback() {
//				dismissed()
//				self.setDismissedCallback(dismissed: nil)
//			}
			self.onDismissAnimation(popupView: popupView, overlayView: overlayView)
		}
	}
	
	// MARK: - Slide
	// MARK: In
	private func slideViewIn(popupView:UIView, sourceView:UIView, overlayView:UIView, animationType:MJPopupViewAnimation) {
		// Generating Start and Stop Positions
		let sourceSize: CGSize = sourceView.bounds.size
		let popupSize:CGSize = popupView.bounds.size
		var popupStartRect:CGRect
		switch animationType.rawValue {
		case MJPopupViewAnimation.SlideBottomTop.rawValue:
			popupStartRect = CGRect(x: (sourceSize.width - popupSize.width) / 2,
			                        y: sourceSize.height,
			                        width: popupSize.width,
			                        height: popupSize.height)
			break
		case MJPopupViewAnimation.SlideLeftRight.rawValue:
			popupStartRect = CGRect(x: (-sourceSize.width),
			                        y: (sourceSize.height - popupSize.height) / 2,
			                        width: popupSize.width,
			                        height: popupSize.height)
			break
		case MJPopupViewAnimation.SlideTopBottom.rawValue:
			popupStartRect = CGRect(x: (sourceSize.width - popupSize.width) / 2,
			                        y: -sourceSize.height,
			                        width: popupSize.width,
			                        height: popupSize.height)
			break
		default:
			popupStartRect = CGRect(x: sourceSize.width,
			                        y: (sourceSize.height - popupSize.height) / 2,
			                        width: popupSize.width,
			                        height: popupSize.height)
			break
		}

		let popupEndRect:CGRect = CGRect(x: (sourceSize.width - popupSize.width) / 2,
		                                 y: (sourceSize.width - popupSize.height) / 2,
		                                 width: popupSize.width,
		                                 height: popupSize.height)
		
		// Set starting properties
		popupView.frame = popupStartRect
		popupView.alpha = 1.0
		
		// Animation
		UIView.animate(withDuration: UIViewController.kPopupModalAnimationDuration, animations: {
			UIViewController.mj_popupViewController?.viewWillAppear(false)
			UIViewController.mj_popupBackgroundView?.alpha = 1.0
			popupView.frame = popupEndRect
		}) { (Bool) in
			UIViewController.mj_popupViewController?.viewDidAppear(false)
		}
	}
	
	private func slideViewOut(popupView:UIView, sourceView:UIView, overlayView:UIView, animationType:MJPopupViewAnimation) {
		// Generating Start and Stop Positions
		let sourceSize: CGSize = sourceView.bounds.size
		let popupSize:CGSize = popupView.bounds.size
		var popupEndRect:CGRect
		switch MJPopupViewAnimation.SlideBottomTop.rawValue {
		case MJPopupViewAnimation.SlideBottomTop.rawValue:
			popupEndRect = CGRect(x: (sourceSize.width - popupSize.width) / 2,
			                      y: (-popupSize.height),
			                      width: popupSize.width,
			                      height: popupSize.height)
			break
			case MJPopupViewAnimation.SlideTopBottom.rawValue:
				popupEndRect = CGRect(x: (sourceSize.width - popupSize.width) / 2,
				                      y: sourceSize.height,
				                      width: popupSize.width,
				                      height: popupSize.height)
			break
		case MJPopupViewAnimation.SlideLeftRight.rawValue:
			popupEndRect = CGRect(x: sourceSize.width,
			                      y: popupView.frame.origin.y,
			                      width: popupSize.width,
			                      height: popupSize.height)
			break
		default:
			popupEndRect = CGRect(x: -popupSize.width,
			                      y: popupView.frame.origin.y,
			                      width: popupSize.width,
			                      height: popupSize.height)
			break
		}

		// Animation
		UIView.animate(withDuration: UIViewController.kPopupModalAnimationDuration, animations: { 
			UIViewController.mj_popupViewController?.viewWillDisappear(false)
			popupView.frame = popupEndRect
			UIViewController.mj_popupBackgroundView?.alpha = 0.0
		}) { (Bool) in
//			popupView.removeFromSuperview()
//			overlayView.removeFromSuperview()
//			UIViewController.mj_popupViewController?.viewDidDisappear(false)
//			UIViewController.mj_popupViewController = nil
//			
//			if let dismissed = self.dismissedCallback() {
//				dismissed()
//				self.setDismissedCallback(dismissed: nil)
//			}
			self.onDismissAnimation(popupView: popupView, overlayView: overlayView)
		}
		
	}
	
	// MARK: - +++Dismissed Selector Callback+++
	// MARK: Set
	private func setDismissedCallback(dismissed:(() -> Void)?) {
		UIViewController.dismissSelector = dismissed
//		if dismissed != nil {
//			objc_setAssociatedObject(self,
//			                         &UIViewController.dismissSelector,
//			                         key,
//			                         objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//		}
	}
	// MARK: Get
	private func dismissedCallback() -> (() -> Void)? {
//		if let selector = objc_getAssociatedObject(self, key) {
//			return selector as! (() -> Void)
//		}
//		return nil
		return UIViewController.dismissSelector
	}

	private func onDismissAnimation(popupView:UIView, overlayView:UIView) {
		popupView.removeFromSuperview()
		overlayView.removeFromSuperview()
		UIViewController.mj_popupViewController?.viewDidDisappear(false)
		UIViewController.mj_popupViewController = nil
		
		guard let dismissed = self.dismissedCallback() else {
			return
		}
		
		dismissed()
		self.setDismissedCallback(dismissed: nil)
	}
}
