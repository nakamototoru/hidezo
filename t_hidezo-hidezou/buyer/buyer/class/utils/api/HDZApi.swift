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
	
//    #if (arch(i386) || arch(x86_64)) && os(iOS)
//	// シミュレータ
//    // 開発サーバー
//    private static let BASE_URL: String = "https://dev-api.hidezo.co"
//    #else
//	// デバイス
//    // 本番サーバー
////    private static let BASE_URL: String = "https://api.hidezo.co"
//    // 開発サーバー
//    private static let BASE_URL: String = "https://dev-api.hidezo.co"
//    #endif
	
}

// MARK: - Login
extension HDZApi {

    internal class func loginCheck(id: String, password: String, completionBlock: @escaping (_ unboxable: LoginCheckResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: LoginCheckError?) -> Void) -> DataRequest? {
		
        let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/login_check/store"
        let parameters: LoginCheck = LoginCheck(id: id, uuid: HDZUserDefaults.uuid, password: password)
        //return AlamofireUtils.request(.get, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
		return AlamofireManager.requesrJson(method: .get, url: requestUrl, parameters: parameters, completed: completionBlock, failed: errorBlock)
    }

    internal class func login(login_id: String,
                              password: String,
                              completionBlock: @escaping (_ unboxable: LoginResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: LoginResult?) -> Void) -> DataRequest? {
		
        let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/login/attempt" //"/login/store"
		let parameters: Login = Login(login_id: login_id, uuid: HDZUserDefaults.uuid, pass: password, device_div:"1") // <-iOS
        //return AlamofireUtils.request(.POST, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
		return AlamofireManager.requesrJson(method: .post, url: requestUrl, parameters: parameters, completed: completionBlock, failed: errorBlock)
    }
}

// MARK: - friend
extension HDZApi {
    
    internal class func friend(completionBlock: @escaping (_ unboxable: FriendResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: FriendError?) -> Void) -> DataRequest? {
        let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/friend"
        let parameters: Friend = Friend(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid)
        
        let error: (_ error: Error?, _ unboxable: FriendError?) -> Void = { (error: Error?, unboxable: FriendError?) -> Void in
            guard let failure: FriendError = unboxable else {
                errorBlock(error, unboxable)
                return
            }

            if self.checkLogOut(result: failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error, unboxable)
        }
        
        //return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
		return AlamofireManager.requesrJson(method: .get, url: requestUrl, parameters: parameters, completed: completionBlock, failed: error)
    }
}

// MARK: - order
extension HDZApi {
	
	// 注文実行
    internal class func order(supplier_id: String, deliver_to: String, delivery_day: String, charge: String, items: Results<HDZOrder>, completionBlock: @escaping (_ unboxable: OrderResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: OrderError?) -> Void) {
		
		//
        let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/order"
        
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

        //AlamofireUtils.request(.POST, requestUrl, structParameters: order, completionBlock: completionBlock, errorBlock: errorBlock)
		let _ = AlamofireManager.requesrJson(method: .post, url: requestUrl, parameters: order, completed: completionBlock, failed: errorBlock)
    }
	
	// 注文履歴
    internal class func orderList(page: Int, completionBlock: @escaping (_ unboxable: OrderListResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: OrderListError?) -> Void) -> DataRequest? {
		
        let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/order_list"
        let parameters: OrderList = OrderList(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, page: page)

        let error: (_ error: Error?, _ unboxable: OrderListError?) -> Void = { (error: Error?, unboxable: OrderListError?) -> Void in
            guard let failure: OrderListError = unboxable else {
                errorBlock(error, unboxable)
                return
            }
            
            if self.checkLogOut(result: failure.result, message: failure.message) {
                return
            }
			
            errorBlock(error, unboxable)
        }

        //return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
		return AlamofireManager.requesrJson(method: .get, url: requestUrl, parameters: parameters, completed: completionBlock, failed: error)
    }
	
	// 注文詳細
    internal class func orderDitail(orderNo: String, completionBlock: @escaping (_ unboxable: OrderDetailResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: OrderDetailError?) -> Void) -> DataRequest? {
		
        let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/order_detail"
        let parameters: OrderDetail = OrderDetail(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, order_no: orderNo)
        
        let error: (_ error: Error?, _ unboxable: OrderDetailError?) -> Void = { (error: Error?, unboxable: OrderDetailError?) -> Void in
            guard let failure: OrderDetailError = unboxable else {
                errorBlock(error, unboxable)
                return
            }
            
            if self.checkLogOut(result: failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error, unboxable)
        }

        //return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
		return AlamofireManager.requesrJson(method: .get, url: requestUrl, parameters: parameters, completed: completionBlock, failed: error)
    }
}

// MARK: - me
extension HDZApi {
    
    internal class func me(completionBlock: @escaping (_ unboxable: MeResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: MeError?) -> Void) -> DataRequest? {
        let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/me"
        let parameters: Me = Me(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid)
        
        let error: (_ error: Error?, _ unboxable: MeError?) -> Void = { (error: Error?, unboxable: MeError?) -> Void in
            guard let failure: MeError = unboxable else {
                errorBlock(error, unboxable)
                return
            }
            
            if self.checkLogOut(result: failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error, unboxable)
        }

        //return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
		return AlamofireManager.requesrJson(method: .get, url: requestUrl, parameters: parameters, completed: completionBlock, failed: error)
    }
}

// MARK: - message
extension HDZApi {
    
    internal class func message(order_no: String, completionBlock: @escaping (_ unboxable: MessageResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: MessageError?) -> Void) -> DataRequest? {
		
        let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/message"
        let parameters: Message = Message(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, order_no: order_no)
        
        let error: (_ error: Error?, _ unboxable: MessageError?) -> Void = { (error: Error?, unboxable: MessageError?) -> Void in
            guard let failure: MessageError = unboxable else {
                errorBlock(error, unboxable)
                return
            }
            
            if self.checkLogOut(result: failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error, unboxable)
        }

       // return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
		return AlamofireManager.requesrJson(method: .get, url: requestUrl, parameters: parameters, completed: completionBlock, failed: error)
    }
    
    internal class func adMessage(order_no: String, charge: String, message: String, completionBlock: @escaping (_ unboxable: MessageAddResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: MessageAddError?) -> Void) -> DataRequest? {
		
        let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/add_message"
        let parameters: MessageAdd = MessageAdd(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, charge: charge, message: message, order_no: order_no)

        let error: (_ error: Error?, _ unboxable: MessageAddError?) -> Void = { (error: Error?, unboxable: MessageAddError?) -> Void in
            
            guard let failure: MessageAddError = unboxable else {
                errorBlock(error, unboxable)
                return
            }
            
            if self.checkLogOut(result: failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error, unboxable)
        }

        //return AlamofireUtils.request(.POST, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
		return AlamofireManager.requesrJson(method: .post, url: requestUrl, parameters: parameters, completed: completionBlock, failed: error)
    }
}

// MARK: - Item
extension HDZApi {
    
    internal class func item(supplierId: String, completionBlock: @escaping (_ unboxable: ItemResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: ItemError?) -> Void) -> DataRequest? {
		
        let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/item"
        let parameters: Item = Item(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, supplier_id: supplierId)
        
        let error: (_ error: Error?, _ unboxable: ItemError?) -> Void = { (error, unboxable) in
            guard let failure: ItemError = unboxable else {
                errorBlock(error, unboxable)
                return
            }
            
            if self.checkLogOut(result: failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error, unboxable)
        }
        
        //return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
		return AlamofireManager.requesrJson(method: .get, url: requestUrl, parameters: parameters, completed: completionBlock, failed: error)
    }
    
    // 注文履歴からの一覧
    internal class func orderd_item(supplierId:String, completionBlock:@escaping (_ unboxable:OrderdItemResult?) -> Void, errorBlock:@escaping (_ error:Error?, _ unboxable:ItemError?) -> Void) -> DataRequest? {
        
        let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/orderd_item"
        let parameters: Item = Item(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, supplier_id: supplierId)
        let error: (_ error: Error?, _ unboxable: ItemError?) -> Void = { (error, unboxable) in
            guard let failure: ItemError = unboxable else {
                errorBlock(error, unboxable)
                return
            }
            if self.checkLogOut(result: failure.result, message: failure.message) {
                return
            }
            errorBlock(error, unboxable)
        }
        //return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
		return AlamofireManager.requesrJson(method: .get, url: requestUrl, parameters: parameters, completed: completionBlock, failed: error)
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

        guard let viewController: UIViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return false
        }

        let handler: (UIAlertAction) -> Void = { (alert: UIAlertAction) in
			
			// ログアウト実行
			let _ = HDZApi.logOut(completionBlock: { (unboxable) in
				// No method
			}, errorBlock: { (error, unboxable) in
				// No method
			})
			
            let controller: HDZTopViewController = HDZTopViewController.createViewController()
            UIApplication.setRootViewController(viewController: controller)
            
            let navigationController: UINavigationController = HDZLoginViewController.createViewController()
            viewController.present(navigationController, animated: true, completion: nil)
        }
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        let comment: String = "他の端末でお客様のアカウントにログインしたか、サーバーの不具合でログアウトされました。"
        let controller: UIAlertController = UIAlertController(title: message, message: comment, preferredStyle: .alert)

        controller.addAction(action)
        viewController.present(controller, animated: true, completion: nil)
        
        return true
    }
	
	internal class func logOut(completionBlock: (_ unboxable: LogoutResult?) -> Void, errorBlock: (_ error: Error?, _ unboxable: LoginCheckError?) -> Void) -> DataRequest? {

		HDZUserDefaults.login = false
		
		let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/logout" //"/store/logout"
		let parameters: ParamsBadge = ParamsBadge(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid)
		let completion:(_ unboxable:LogoutResult?) ->Void = { (unboxable) in
			// カートを空に
			try! HDZOrder.deleteAll()
		}
		let error:(_ error:Error?, _ unboxable:LoginCheckError?) -> Void = { (error,unboxable) in
			// カートを空に
			try! HDZOrder.deleteAll()
		}
		//return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completion, errorBlock: error)
		return AlamofireManager.requesrJson(method: .get, url: requestUrl, parameters: parameters, completed: completion, failed: error)
	}
}

// MARK: - PushNotification
extension HDZApi {
	
	// トークン送信
	internal class func postDeviceToken(id: String, completionBlock: @escaping (_ unboxable: DeviceTokenResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: DeviceTokenError?) -> Void) -> DataRequest? {

		let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/device_token"
		let parameters: DeviceToken = DeviceToken(id: id, uuid: HDZUserDefaults.uuid, device_token: HDZUserDefaults.devicetoken, device_flg: "1")
		//return AlamofireUtils.request(.POST, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
		return AlamofireManager.requesrJson(method: .post, url: requestUrl, parameters: parameters, completed: completionBlock, failed: errorBlock)
	}

	internal class func postDeviceTokenByLogin() {
		
		let completionToken: (_ unboxable: DeviceTokenResult?) -> Void = { (unboxable) in
			debugPrint("****** completionToken ******")
		}
		let errorToken: (_ error: Error?, _ result: DeviceTokenError?) -> Void = { (error, result) in
			debugPrint(error.debugDescription)
		}
		let _:Alamofire.Request = HDZApi.postDeviceToken(id: HDZUserDefaults.id, completionBlock: completionToken, errorBlock: errorToken)!

	}

}

// MARK: - Badge
extension HDZApi {
	
	// バッジ取得
	internal class func badge(completionBlock: @escaping (_ unboxable: BadgeResult?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: BadgeError?) -> Void) -> DataRequest? {
		
		let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/badge"
		let parameters: ParamsBadge = ParamsBadge(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid)
		//return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
		return AlamofireManager.requesrJson(method: .get, url: requestUrl, parameters: parameters, completed: completionBlock, failed: errorBlock)
	}
	
	
	// バッジリセット
	internal class func postCheckDynamicItems(supplier_id: String, completionBlock: @escaping (_ unboxable: CheckDynamicItemsResultComplete?) -> Void, errorBlock: @escaping (_ error: Error?, _ unboxable: CheckDynamicItemsResultError?) -> Void) -> DataRequest? {
		
		let requestUrl: String = HDZConfiguration.ApiBaseUrl() + "/store/check_dynamic_items"
		let parameters: CheckDynamicItemsRequest = CheckDynamicItemsRequest(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid, supplier_id: supplier_id )
		//return AlamofireUtils.request(.POST, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
		return AlamofireManager.requesrJson(method: .post, url: requestUrl, parameters: parameters, completed: completionBlock, failed: errorBlock)
	}
}

// MARK: - FAX
extension HDZApi {
	
	// 送信
	internal class func sendFax(orderNo:String, completeBlock:@escaping (_ unboxable:FaxResult?) -> Void, errorBlock:@escaping (_ error:Error?, _ unboxable:FaxError?) -> Void) -> DataRequest? {
		
		let requestUrl = HDZConfiguration.ApiBaseUrl() + "/store/fax/" + orderNo
		let parameters = FaxParam(id: HDZUserDefaults.id, uuid: HDZUserDefaults.uuid)
		//return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completeBlock, errorBlock: errorBlock)
		return AlamofireManager.requesrJson(method: .get, url: requestUrl, parameters: parameters, completed: completeBlock, failed: errorBlock)
	}
	
}
