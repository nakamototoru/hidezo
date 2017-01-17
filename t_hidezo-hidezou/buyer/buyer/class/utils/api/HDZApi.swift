//
//  HDZApi.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import Unbox

internal class HDZApi {
	
	// 開発用サーバー
	// TODO:開発用アドレスなので申請前には本番に変更しておく
//    private static let BASE_URL: String = "https://dev-api.hidezo.co"
	
    #if (arch(i386) || arch(x86_64)) && os(iOS)
	// シミュレータ
	// 本番サーバー
	private static let BASE_URL: String = "https://api.hidezo.co"
    // 開発サーバー
//    private static let BASE_URL: String = "https://dev-api.hidezo.co"
    #else
	// デバイス
    // 本番サーバー
    private static let BASE_URL: String = "https://api.hidezo.co"
    // 開発サーバー
//    private static let BASE_URL: String = "https://dev-api.hidezo.co"
    #endif
}

// MARK: - Login
extension HDZApi {

    internal class func loginCheck(id: String, password: String, completionBlock: (unboxable: LoginCheckResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: LoginCheckError?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/login_check/store"
        let parameters: LoginCheck = LoginCheck(id: id, uuid: HDZUserDefaults.uuid, password: password)
        return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
    }

    internal class func login(login_id: String, password: String, completionBlock: (unboxable: LoginResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: LoginResult?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/store/login/attempt" //"/login/store"
		let parameters: Login = Login(login_id: login_id, uuid: HDZUserDefaults.uuid, pass: password, device_div:"1") // <-iOS
        return AlamofireUtils.request(.POST, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
    }
}

// MARK: - friend
extension HDZApi {
    
    internal class func friend(completionBlock: (unboxable: FriendResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: FriendError?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/store/friend"
        let parameters: Friend = Friend(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid)
        
        let error: (error: ErrorType?, unboxable: FriendError?) -> Void = { (error: ErrorType?, unboxable: FriendError?) -> Void in
            guard let failure: FriendError = unboxable else {
                errorBlock(error: error, unboxable: unboxable)
                return
            }

            if self.checkLogOut(failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error: error, unboxable: unboxable)
        }
        
        return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
    }
}

// MARK: - order
extension HDZApi {
	
	// 注文実行
    internal class func order(supplier_id: String, deliver_to: String, delivery_day: String, charge: String, items: Results<HDZOrder>, completionBlock: (unboxable: OrderResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: OrderError?) -> Void) {
		
		//
        let requestUrl: String = BASE_URL + "/store/order"
        
        var dynamic_item: [String] = []
        var static_item: [String] = []
        
        for item in items {
            if item.dynamic {
				
				dynamic_item.append(String(item.itemId) + "," + item.size)
            }
			else {
				
				static_item.append(String(item.itemId) + "," + item.size)
            }
        }
		
        let order: Order = Order(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, supplier_id: supplier_id, static_item: static_item, dynamic_item: dynamic_item, deliver_to: deliver_to, delivery_day: delivery_day, charge: charge)

//		#if DEBUG
//			debugPrint(order)
//		#endif

        AlamofireUtils.request(.POST, requestUrl, structParameters: order, completionBlock: completionBlock, errorBlock: errorBlock)
    }
	
	// 注文履歴
    internal class func orderList(page: Int, completionBlock: (unboxable: OrderListResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: OrderListError?) -> Void) -> Alamofire.Request? {
		
        let requestUrl: String = BASE_URL + "/store/order_list"
        let parameters: OrderList = OrderList(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, page: page)

        let error: (error: ErrorType?, unboxable: OrderListError?) -> Void = { (error: ErrorType?, unboxable: OrderListError?) -> Void in
            guard let failure: OrderListError = unboxable else {
                errorBlock(error: error, unboxable: unboxable)
                return
            }
            
            if self.checkLogOut(failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error: error, unboxable: unboxable)
        }

        return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
    }
	
	// 注文詳細
    internal class func orderDitail(orderNo: String, completionBlock: (unboxable: OrderDetailResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: OrderDetailError?) -> Void) -> Alamofire.Request? {
		
        let requestUrl: String = BASE_URL + "/store/order_detail"
        let parameters: OrderDetail = OrderDetail(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, order_no: orderNo)
        
        let error: (error: ErrorType?, unboxable: OrderDetailError?) -> Void = { (error: ErrorType?, unboxable: OrderDetailError?) -> Void in
            guard let failure: OrderDetailError = unboxable else {
                errorBlock(error: error, unboxable: unboxable)
                return
            }
            
            if self.checkLogOut(failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error: error, unboxable: unboxable)
        }

        return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
    }
}

// MARK: - me
extension HDZApi {
    
    internal class func me(completionBlock: (unboxable: MeResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: MeError?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/store/me"
        let parameters: Me = Me(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid)
        
        let error: (error: ErrorType?, unboxable: MeError?) -> Void = { (error: ErrorType?, unboxable: MeError?) -> Void in
            guard let failure: MeError = unboxable else {
                errorBlock(error: error, unboxable: unboxable)
                return
            }
            
            if self.checkLogOut(failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error: error, unboxable: unboxable)
        }

        return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
    }
}

// MARK: - message
extension HDZApi {
    
    internal class func message(order_no: String, completionBlock: (unboxable: MessageResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: MessageError?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/store/message"
        let parameters: Message = Message(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, order_no: order_no)
        
        let error: (error: ErrorType?, unboxable: MessageError?) -> Void = { (error: ErrorType?, unboxable: MessageError?) -> Void in
            guard let failure: MessageError = unboxable else {
                errorBlock(error: error, unboxable: unboxable)
                return
            }
            
            if self.checkLogOut(failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error: error, unboxable: unboxable)
        }

        return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
    }
    
    internal class func adMessage(order_no: String, charge: String, message: String, completionBlock: (unboxable: MessageAddResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: MessageAddError?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/store/add_message"
        let parameters: MessageAdd = MessageAdd(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, charge: charge, message: message, order_no: order_no)

        let error: (error: ErrorType?, unboxable: MessageAddError?) -> Void = { (error: ErrorType?, unboxable: MessageAddError?) -> Void in
            
            guard let failure: MessageAddError = unboxable else {
                errorBlock(error: error, unboxable: unboxable)
                return
            }
            
            if self.checkLogOut(failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error: error, unboxable: unboxable)
        }

        return AlamofireUtils.request(.POST, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
        
    }
}

// MARK: - Item
extension HDZApi {
    
    internal class func item(supplierId: String, completionBlock: (unboxable: ItemResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: ItemError?) -> Void) -> Alamofire.Request? {
		
        let requestUrl: String = BASE_URL + "/store/item"
        let parameters: Item = Item(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, supplier_id: supplierId)
        
        let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
            guard let failure: ItemError = unboxable else {
                errorBlock(error: error, unboxable: unboxable)
                return
            }
            
            if self.checkLogOut(failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error: error, unboxable: unboxable)
        }
        
        return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
    }
    
    // 注文履歴からの一覧
    internal class func orderd_item(supplierId:String, completionBlock:(unboxable:OrderdItemResult?) -> Void, errorBlock:(error:ErrorType?, unboxable:ItemError?) -> Void) -> Alamofire.Request? {
        
        let requestUrl: String = BASE_URL + "/store/orderd_item"
        let parameters: Item = Item(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, supplier_id: supplierId)
        let error: (error: ErrorType?, unboxable: ItemError?) -> Void = { (error, unboxable) in
            guard let failure: ItemError = unboxable else {
                errorBlock(error: error, unboxable: unboxable)
                return
            }
            if self.checkLogOut(failure.result, message: failure.message) {
                return
            }
            errorBlock(error: error, unboxable: unboxable)
        }
        return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
    }
}

// MARK: - logout check
extension HDZApi {
    
    internal class func checkLogOut(result: Bool, message: String) -> Bool {
        
        if message == "データがありません" {
            return false
        }
        
        if result {
            return false
        }

        guard let viewController: UIViewController = UIApplication.sharedApplication().keyWindow?.rootViewController else {
            return false
        }

        let handler: (UIAlertAction) -> Void = { (alert: UIAlertAction) in
			
			// ログアウト実行
			HDZApi.logOut({ (unboxable) in
				}, errorBlock: { (error, unboxable) in
			})
			
            let controller: HDZTopViewController = HDZTopViewController.createViewController()
            UIApplication.setRootViewController(controller)
            
            let navigationController: UINavigationController = HDZLoginViewController.createViewController()
            viewController.presentViewController(navigationController, animated: true, completion: nil)
        }
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: handler)
        let comment: String = "他の端末でお客様のアカウントにログインしたか、サーバーの不具合でログアウトされました。"
        let controller: UIAlertController = UIAlertController(title: message, message: comment, preferredStyle: .Alert)

        controller.addAction(action)
        viewController.presentViewController(controller, animated: true, completion: nil)
        
        return true
    }
	
	internal class func logOut(completionBlock: (unboxable: LoginResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: LoginCheckError?) -> Void) -> Alamofire.Request? {

		HDZUserDefaults.login = false
		
		let requestUrl: String = BASE_URL + "/logout" //"/store/logout"
		let parameters: ParamsBadge = ParamsBadge(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid)
		let completion:(unboxable:LoginResult?) ->Void = { (unboxable) in
			// カートを空に
			try! HDZOrder.deleteAll()
		}
		let error:(error:ErrorType?, unboxable:LoginCheckError?) -> Void = { (error,unboxable) in
			// カートを空に
			try! HDZOrder.deleteAll()
		}
		return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completion, errorBlock: error)
	}
}

// MARK: - PushNotification
extension HDZApi {
	
	// トークン送信
	internal class func postDeviceToken(id: String, completionBlock: (unboxable: DeviceTokenResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: DeviceTokenResult?) -> Void) -> Alamofire.Request? {

		let requestUrl: String = BASE_URL + "/store/device_token"
		let parameters: DeviceToken = DeviceToken(id: id, uuid: HDZUserDefaults.uuid, device_token: HDZUserDefaults.devicetoken, device_flg: "1")
		return AlamofireUtils.request(.POST, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
	}

	internal class func postDeviceTokenByLogin() {
		
		let completionToken: (unboxable: DeviceTokenResult?) -> Void = { (unboxable) in
			debugPrint("****** completionToken ******")
		}
		let errorToken: (error: ErrorType?, result: DeviceTokenResult?) -> Void = { (error, result) in
			debugPrint(error)
		}
		let _:Alamofire.Request = HDZApi.postDeviceToken(HDZUserDefaults.id, completionBlock: completionToken, errorBlock: errorToken)!

	}

}

// MARK: - Badge
extension HDZApi {
	
	// バッジ取得
	internal class func badge(completionBlock: (unboxable: BadgeResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: BadgeError?) -> Void) -> Alamofire.Request? {
		
		let requestUrl: String = BASE_URL + "/store/badge"
		let parameters: ParamsBadge = ParamsBadge(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid)
		return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
	}
	
	
	// バッジリセット
	internal class func postCheckDynamicItems(supplier_id: String, completionBlock: (unboxable: CheckDynamicItemsResultComplete?) -> Void, errorBlock: (error: ErrorType?, unboxable: CheckDynamicItemsResultError?) -> Void) -> Alamofire.Request? {
		
		let requestUrl: String = BASE_URL + "/store/check_dynamic_items"
		let parameters: CheckDynamicItemsRequest = CheckDynamicItemsRequest(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, supplier_id: supplier_id )
		return AlamofireUtils.request(.POST, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
	}
}

// MARK: - FAX
extension HDZApi {
	
	// 注文送信方法取得
	internal class func getOrderMethod(supplierId:String, completeBlock:(unboxable:OrderMethodResult?) -> Void, errorBlock:(error:ErrorType?, unboxable:OrderListError?) -> Void) -> Alamofire.Request? {
		
		let requestUrl = BASE_URL + "/store/order_method"
		let parameters = OrderMethod(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, supplier_id:supplierId)
		return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completeBlock, errorBlock: errorBlock)
	}
	
	// 発注書情報取得
	internal class func getFaxDoc(orderNo:String, completeBlock:(unboxable:FaxDocResult?) -> Void, errorBlock:(error:ErrorType?, unboxable:OrderListError?) -> Void) -> Alamofire.Request? {

		let requestUrl = BASE_URL + "/store/faxdoc"
		let parameters = FaxDoc(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, order_no: orderNo)
		return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completeBlock, errorBlock: errorBlock)
	}
}
