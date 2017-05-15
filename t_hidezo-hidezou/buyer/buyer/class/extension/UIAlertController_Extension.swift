//
//  UIAlertController_Extension.swift
//  
//
//  Created by 庄俊亮 on 2017/03/04.
//
//

import UIKit

/**
 * Android書式なダイアログ作成
[Usage]

UIAlertController(title: "ログイン", message: "IDを入力してください", preferredStyle: .alert)
.addTextField { textField in
	textField.placeholder = "ID"
}
.addActionWithTextFields(title: "OK") { action, textFields in
	doValidateMethod()
}
.addAction(title: "キャンセル", style: .cancel)
.show()

*/
extension UIAlertController {
	
	func addAction(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
		let okAction = UIAlertAction(title: title, style: style, handler: handler)
		addAction(okAction)
		return self
	}
	
//	func addActionWithTextFields(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction, [UITextField]) -> Void)? = nil) -> Self {
//		let okAction = UIAlertAction(title: title, style: style) { [weak self] action in
//			handler?(action, self?.textFields ?? [])
//		}
//		addAction(okAction)
//		return self
//	}
//	func addTextField(handler: @escaping (UITextField) -> Void) -> Self {
//		addTextField(configurationHandler: handler)
//		return self
//	}
	
	func configureForIPad(sourceRect: CGRect, sourceView: UIView? = nil) -> Self {
		popoverPresentationController?.sourceRect = sourceRect
		if let sourceView = UIApplication.shared.topViewController?.view {
			popoverPresentationController?.sourceView = sourceView
		}
		return self
	}
	
	func configureForIPad(barButtonItem: UIBarButtonItem) -> Self {
		popoverPresentationController?.barButtonItem = barButtonItem
		return self
	}
	
	func show() {
		// 最前面のUIViewControllerを取得してモーダル表示
		//		UIApplication.shared.topViewController?.present(self, animated: true, completion: nil)
		UIApplication.getBaseViewController()?.present(self, animated: true, completion: nil)
	}
	func show(animated: Bool) {
		UIApplication.getBaseViewController()?.present(self, animated: animated, completion: nil)
	}
}
