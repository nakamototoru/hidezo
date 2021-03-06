//
//  HDZApi.swift
//  seller
//
//  Created by NakaharaShun on 6/20/16.
//  Copyright © 2016 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire

internal class HDZApi {
    
    private static let BASE_URL: String = "https://dev-api.hidezo.co"
}

// MARK: - Login
extension HDZApi {

    internal class func loginCheck(id: Int, password: String, completionBlock: (unboxable: LoginCheckResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: LoginCheckError?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/login_check/supplier"
        let parameters: LoginCheck = LoginCheck(id: id, uuid: HDZUserDefaults.uuid, password: password)
        return AlamofireUtils.request(.GET, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
    }

    internal class func login(id: Int, password: String, completionBlock: (unboxable: LoginResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: LoginResult?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/login/supplier"
        let parameters: Login = Login(id: id, uuid: HDZUserDefaults.uuid, password: password)
        return AlamofireUtils.request(.POST, requestUrl, structParameters: parameters, completionBlock: completionBlock, errorBlock: errorBlock)
    }
}

// MARK: - friend
extension HDZApi {
    
    internal class func friend(completionBlock: (unboxable: FriendResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: FriendError?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/supplier/friend"
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
    
    internal class func orderList(page: Int, completionBlock: (unboxable: OrderListResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: OrderListError?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/supplier/order_list"
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
    
    internal class func orderDitail(orderNo: String, completionBlock: (unboxable: OrderDetailResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: OrderDetailError?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/supplier/order_detail"
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
    
    internal class func orderUpdate(parameters: OrderUpdate, completionBlock: (unboxable: OrderUpdateResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: OrderUpdateError?) -> Void) -> Alamofire.Request? {
        let requesturl: String = BASE_URL + "/supplier/order_update"
        let error: (error: ErrorType?, unboxable: OrderUpdateError?) -> Void = { (error: ErrorType?, unboxable: OrderUpdateError?) in
            guard let failure: OrderUpdateError = unboxable else {
                errorBlock(error: error, unboxable: unboxable)
                return
            }
            
            if self.checkLogOut(failure.result, message: failure.message) {
                return
            }
            
            errorBlock(error: error, unboxable: unboxable)

        }
        return AlamofireUtils.request(.POST, requesturl, structParameters: parameters, completionBlock: completionBlock, errorBlock: error)
        
    }
}

// MARK: - me
extension HDZApi {
    
    internal class func me(completionBlock: (unboxable: MeResult?) -> Void, errorBlock: (error: ErrorType?, unboxable: MeError?) -> Void) -> Alamofire.Request? {
        let requestUrl: String = BASE_URL + "/supplier/me"
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
        let requestUrl: String = BASE_URL + "/supplier/message"
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
        let requestUrl: String = BASE_URL + "/supplier/add_message"
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
            
            HDZUserDefaults.login = false

            let controller: HDZTopViewController = HDZTopViewController.createViewController()
            UIApplication.setRootViewController(controller)
            
            let navigationController: UINavigationController = HDZLoginViewController.createViewController()
//            viewController.present(navigationController, animated: true, completion: nil)
			viewController.presentViewController(navigationController, animated: true, completion: nil);
        }
        
        //let action: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: handler)
		let action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: handler)
        
        let comment: String = "他の端末でお客様のアカウントにログインしたか、サーバーの不具合でログアウトされました。"
        let controller: UIAlertController = UIAlertController(title: message, message: comment, preferredStyle: UIAlertControllerStyle.Alert)

        controller.addAction(action)
        viewController.presentViewController(controller, animated: true, completion: nil)
        
        return true
    }
}



