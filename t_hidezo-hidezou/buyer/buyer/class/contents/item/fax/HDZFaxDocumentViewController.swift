//
//  HDZFaxDocumentViewController.swift
//  buyer
//
//  Created by 庄俊亮 on 2017/01/13.
//  Copyright © 2017年 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class HDZFaxDocumentViewController: UIViewController {
	
	@IBOutlet weak var scrollViewDocument: UIScrollView!
	
	private var orderNumber = ""
	private var faxNumber = ""
	private var arrayPageView:[UIView] = []

	private var indicatorView:CustomIndicatorView!

	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		//インジケータ
		self.indicatorView = CustomIndicatorView.createView(self.view.frame.size)
		self.view.addSubview(self.indicatorView)

    }

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.apiGetFaxDoc()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func createFaxDocView(faxdoc:FaxDocInfo) {
		
		guard let items:[FaxDocItem] = faxdoc.faxdocitems else {
			return
		}

		// 共通データ
		let nameOfStore:String = faxdoc.store_name // "（自店舗の名前はプロフィールから）"
		let numberOfStore:String = faxdoc.store_code // "????????"

		// 最初ページ
		var countOfPage:Int = 0
		let page1st:HDZPdf1stView = HDZPdf1stView.createView()
		page1st.setClient(faxdoc.supplier_name)
		page1st.setOrderNumber(self.orderNumber)
		page1st.setShopName(nameOfStore, number: numberOfStore)
		page1st.setResidence(faxdoc.store_address)
		page1st.setOrderDate(faxdoc.order_at)
		page1st.setDeliveryDate(faxdoc.deliver_at)
		page1st.setOptionNote(faxdoc.comment)
		// 商品一覧
		page1st.setupSheetRows()
		var countItem = 0
		for item in items {
			page1st.setRowValue(item.name, number: item.id, orderSize: item.size)
			countItem += 1
			if countItem >= HDZPdf1stView.maxRowCount {
				break
			}
		}

		countOfPage += 1
		arrayPageView.append(page1st)

		// 2枚目以降ページ
		let countALLItem = items.count
		if countItem < countALLItem {
			
//			let page2nd:HDZPdf2ndView = HDZPdf2ndView.createView()
//			page2nd.frame = CGRectOffset(page2nd.frame, 0, PDFMaker.heightApage)
//			countOfPage += 1
//			arrayPageView.append(page2nd)
			
//			var countLast = countALLItem - countItem
			var moveY = PDFMaker.heightApage
			while countItem < countALLItem {
				let page2nd:HDZPdf2ndView = HDZPdf2ndView.createView()
				page2nd.setStoreValue(nameOfStore, number: numberOfStore)
				page2nd.frame = CGRectOffset(page2nd.frame, 0, moveY)
				countOfPage += 1
				arrayPageView.append(page2nd)
			
				// 商品一覧
				var countSecondItem = 0
				for i in countItem..<items.count {
					let item = items[i]
					page2nd.addRowValue(item.id, product: item.name, orderSize:item.size)
					countSecondItem += 1
					if countSecondItem >= HDZPdf2ndView.maxRowCount {
						break
					}
				}
				countItem += HDZPdf2ndView.maxRowCount
				
				moveY += PDFMaker.heightApage
			}
		}
		
		// 総ページ数
		scrollViewDocument.contentSize = CGSizeMake(PDFMaker.widthApage, PDFMaker.heightApage * CGFloat(countOfPage))
		page1st.setPage(1, All: countOfPage)
		if arrayPageView.count >= 2 {
			for i in 1..<arrayPageView.count {
				let page2nd:HDZPdf2ndView = arrayPageView[i] as! HDZPdf2ndView
				page2nd.setPageValue(i+1, all: countOfPage)
			}
		}
		
		// ビュー追加
		for view in arrayPageView {
			scrollViewDocument.addSubview(view)
		}

	}
	
	private func apiGetFaxDoc() {
		
		let completeHandler:(unboxable:FaxDocResult?) -> Void = { (unboxable) in
			#if DEBUG
				debugPrint("**** getFaxDoc ****")
				debugPrint(unboxable)
				debugPrint("**** getFaxDoc END ****")
			#endif
			
			guard let docResult:FaxDocResult = unboxable else {
				return
			}
			
			self.faxNumber = docResult.faxdoc.fax
			
			self.createFaxDocView(docResult.faxdoc)
		}
		let errorHandler:(error:ErrorType?, unboxable:OrderListError?) -> Void = { (error,Unboxable) in
			debugPrint(error)
		}
		HDZApi.getFaxDoc(self.orderNumber, completeBlock: completeHandler, errorBlock: errorHandler)
	}
	
	private func closeMyself() {
		// 閉じる処理
		self.dismissViewControllerAnimated(true) {
			// 注文履歴タブへ遷移
			// 1.ルートビュー取得
			if let rootvc:UIViewController = (UIApplication.sharedApplication().keyWindow?.rootViewController)! {
				// 2.タブバーコントローラーチェック
				if rootvc.title == "HDZHomeViewController" {
					// 3.タブバータイテム選択
					let tabbarctrl:UITabBarController = rootvc as! UITabBarController
					tabbarctrl.selectedIndex = 1
				}
			}
		}
	}

	// MARK: - アクション
	@IBAction func onCloseSelf(sender: AnyObject) {
		
		let actionOkey = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
			self.closeMyself()
		})
		MyWarning.Alert("FAX送信中止", message: "送信を中止してもよろしいですか？", alertActionOkey: actionOkey)
	}
	
	@IBAction func onSendFax(sender: AnyObject) {
		
		// インジケーター開始
		self.indicatorView.startAnimating()

		// FAX送信開始
		let pageRect:CGRect = CGRectMake(0, 0, PDFMaker.widthApage, PDFMaker.heightApage)
		// FAX送信リクエスト
		let base64Binary:String = PDFMaker.makeForBase64BinaryString(arrayPageView, pageRect:pageRect)
		let completeHandler:(idxcnt:String,accepttime:String) -> Void = { (idxcnt,accepttime) in
			#if DEBUG
				debugPrint(idxcnt + " / " + accepttime)
			#endif
			
			// インジケーター停止
			self.indicatorView.stopAnimating()

			let actionDone = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
				self.closeMyself()
			})
			MyWarning.Dialog("", message: "FAX送信完了", alertActionDone: actionDone)
		}
		let failHandler:(error:NSError) -> Void = { (error) in
			// インジケーター停止
			self.indicatorView.stopAnimating()

			MyWarning.Warning("FAX送信エラー", message: "FAX送信に失敗しました。")
		}
		HDZSoapFax.requestDoSendRequest(base64Binary, telNumber:self.faxNumber, subject:"BuyerFaxTest", completeHandler:completeHandler, failHandler: failHandler)
	}
	
}

extension HDZFaxDocumentViewController {
	
	internal func setupValue(order_no:String) {
		self.orderNumber = order_no
	}
}
