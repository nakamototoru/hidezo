//
//  AlamofireManager.swift
//  buyer
//
//  Created by 庄俊亮 on 2017/05/14.
//  Copyright © 2017年 Shun Nakahara. All rights reserved.
//

import UIKit
import Alamofire
import Wrap
import Unbox

class AlamofireManager: NSObject {
	
	internal class func hogehoge(url: URLConvertible) -> DataRequest {
		
		return Alamofire.request(url)
	}
	
	internal class func request<U: WrapCustomizable>(method: HTTPMethod,
	                            url: URLConvertible,
	                            structParameters: U,
	                            success: @escaping (_ data: Dictionary<String, Any>)-> Void,
	                            fail: @escaping (_ error: Error?)-> Void) -> DataRequest? {
		
		// ラップ
		var wrappedDictionary: WrappedDictionary? = nil
		do {
			wrappedDictionary = try wrap(structParameters)
			
			wrappedDictionary = (wrappedDictionary?.count)! > 0 ? wrappedDictionary : nil
		} catch {
			//errorBlock(error, nil)
			return nil
		}

		#if DEBUG
			debugPrint("+++++++++++++++ Request Start +++++++++++++++++++++++++")
			//debugPrint(request)
			debugPrint( String(describing: wrappedDictionary) )
			debugPrint("+++++++++++++++ Request End +++++++++++++++++++++++++++")
		#endif
		
		// リクエスト
		return Alamofire.request(url, method: method, parameters: wrappedDictionary).responseJSON { response in
			if response.result.isSuccess {
				success(response.result.value as! Dictionary)
			}
			else {
				fail(response.result.error)
			}
		}
	}

	internal class func unboxJson<T: Unboxable>(json: Dictionary<String, Any>,
	                              completionBlock: @escaping (_ unboxable: T?) -> Void,
	                              errorBlock: @escaping (_ error: Error?) -> Void) {
				
		//			#if DEBUG
		//				debugPrint("<<<<<<<<<<<< Response <<<<<<<<<<<<<<<<<<")
		//				debugPrint(result)
		//				debugPrint(">>>>>>>>>>>> Response End >>>>>>>>>>>>>>>>>>")
		//			#endif
		
		
		let unboxvalue:UnboxableDictionary = json
		#if DEBUG
			debugPrint("<<<<<<<<<<<< Response Colum <<<<<<<<<<<<<<<<<<")
			debugPrint(unboxvalue)
			debugPrint("<<<<<<<<<<<< Colum End <<<<<<<<<<<<<<<<<<")
		#endif
				
		do {
			let value: T = try unbox(dictionary: unboxvalue)
			completionBlock(value)
		} catch {
			errorBlock(error)
		}
	}
	
	internal class func requesrJson<U: WrapCustomizable, T: Unboxable, V: Unboxable>(method: HTTPMethod,
	                                url: URLConvertible,
	                                parameters: U,
	                                completed: @escaping (_ unboxable: T?) -> Void,
	                                failed: @escaping (_ error: Error?, _ unboxable: V?) -> Void) -> DataRequest? {
		
		return AlamofireManager.request(method: method, url: url, structParameters: parameters, success: { response in
			AlamofireManager.unboxJson(json: response, completionBlock: { value in
				completed(value)
			}, errorBlock: { error in
				failed(error,nil)
			})
		}) { error in
			failed(error,nil)
		}
	}
	
	internal class func requestData(url: URLConvertible,
	                                success: @escaping (_ data: Data)-> Void,
	                                fail: @escaping (_ error: Error?)-> Void)-> DataRequest? {
		
		return Alamofire.request(url).responseData { response in
			if response.result.isSuccess {
				success(response.result.value!)
			}
			else {
				fail(response.result.error)
			}
		}
	}
	
}
