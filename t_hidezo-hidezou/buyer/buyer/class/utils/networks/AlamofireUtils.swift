
//  AlamofireUtils.swift
//
//  Created by NakaharaShun on 3/6/16.
//  Copyright © 2016 SAKAMA inc. All rights reserved.
//

import UIKit
import Alamofire
import Unbox
import Wrap

public enum AlamofireError: ErrorType {
    case network
    case invalidValue
    case parse
    case statusCode
}

public enum AlamoFireMimeType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"
    case text = "text/plain"
    case json = "application/json"
    
    var contentType: String {
        get {
            return self.rawValue
        }
    }
}

public struct AlamofireBodyPartItem {
    let name: String
    let fileName: String
    let mimeType: AlamoFireMimeType
    let data: NSData
}

//internal typealias MNErrorResponse = (error: ErrorType?, contents: Unboxable?) -> Void //TODO: うまくジェネリクスで定義したい...

internal class AlamofireUtils {
}

// MARK: - request
extension AlamofireUtils {
    
    internal class func request<T: Unboxable, U: WrapCustomizable, V: Unboxable>(method: Alamofire.Method, _ URLString: URLStringConvertible, structParameters: U, encoding: ParameterEncoding = .URL, headers: [String : String]? = nil, completionBlock: (unboxable: T?) -> Void, errorBlock: (error: ErrorType?, unboxable: V?) -> Void) -> Alamofire.Request? {
        
        var wrappedDictionary: WrappedDictionary? = nil
        do {
            wrappedDictionary = try Wrap(structParameters)
            wrappedDictionary = wrappedDictionary?.count > 0 ? wrappedDictionary : nil
        } catch {
            errorBlock(error: error, unboxable: nil)
            return nil
        }
        
        let completionHandler: (Response<AnyObject, NSError>) -> Void = { (response: Response<AnyObject, NSError>) -> Void in
            
//            #if DEBUG
//                debugPrint(response)
//            #endif
			
            var statusCode: Int = 200
            if let nsResponse: NSHTTPURLResponse = response.response {
                statusCode = nsResponse.statusCode
            }
            
            let result: Result<AnyObject, NSError> = response.result
			
			#if DEBUG
				debugPrint("<<<<<<<<<<<< Response <<<<<<<<<<<<<<<<<<")
				debugPrint(result)
				debugPrint(">>>>>>>>>>>> Response End >>>>>>>>>>>>>>>>>>")
			#endif
			
            if (result.isSuccess) {
                if (result.value is [String: AnyObject]) {
					
//					let unboxvalue:UnboxableDictionary = result.value as! UnboxableDictionary
//					#if DEBUG
//					debugPrint(unboxvalue)
//					#endif
					
                    do {
                       let value: T = try Unbox(result.value as! UnboxableDictionary)
						
                        if statusCode >= 200 && statusCode < 300 {
                            completionBlock(unboxable: value)
                        } else {
                            errorBlock(error: AlamofireError.statusCode, unboxable: nil)
                        }
                    } catch {
                        do {
                            let value: V = try Unbox(result.value as! UnboxableDictionary)
                            errorBlock(error: error, unboxable: value)
                        } catch {
                            errorBlock(error: error, unboxable: nil)
                        }
                    }
                } else {
                    errorBlock(error: AlamofireError.invalidValue, unboxable: nil)
                }
            } else if (result.isFailure) {
                errorBlock(error: result.error, unboxable: nil)
            } else {
                errorBlock(error: AlamofireError.network, unboxable: nil)
            }
        }
        
        let request: Request = Alamofire.request(method, URLString, parameters: wrappedDictionary, encoding: encoding, headers: headers).responseJSON(completionHandler: completionHandler)
        #if DEBUG
            debugPrint("+++++++++++++++ Request Start +++++++++++++++++++++++++")
            debugPrint(request)
			debugPrint(wrappedDictionary)
			debugPrint("+++++++++++++++ Request End +++++++++++++++++++++++++++")
        #endif
		
        return request
    }
}

// MARK: - upload
extension AlamofireUtils {
    
    internal class func upload<T: Unboxable, U: WrapCustomizable>(method: Alamofire.Method, _ URLString: URLStringConvertible, structParameters: U, headers:[String : String]? = nil, bodyPart: [AlamofireBodyPartItem], completionBlock: (unboxable: T?) -> Void, errorBlock: (error: ErrorType?, result: T?) -> Void) {
        
        var wrappedDictionary: WrappedDictionary? = nil
        do {
            wrappedDictionary = try Wrap(structParameters)
            wrappedDictionary = wrappedDictionary?.count > 0 ? wrappedDictionary : nil
        } catch {
            errorBlock(error: error, result: nil)
            return
        }
        
        
        let multipartFormData: (MultipartFormData) -> Void = { (multipartFromData: MultipartFormData) in
            
            // POST 情報を送る
            if let metadata: WrappedDictionary = wrappedDictionary {
                for (key, value) in metadata {
                    if let stringValue: String = String(value) {
                        multipartFromData.appendBodyPart(data: stringValue.dataUsingEncoding(NSUTF8StringEncoding)!, name: key, mimeType: AlamoFireMimeType.text.contentType)
                    }
                }
            }
            
            // multi part 情報を送る
            for part in bodyPart {
                multipartFromData.appendBodyPart(data: part.data as NSData, name: part.name, fileName: part.fileName, mimeType: part.mimeType.contentType)
            }
        }
        
        let completionHandler: ((Manager.MultipartFormDataEncodingResult) -> Void) = { (response: Manager.MultipartFormDataEncodingResult) in
            switch response {
            case .Failure(let error):
                errorBlock(error: error, result: nil)
                break
            case .Success(let request, _, _):
                
                let completionHandler: (Response<AnyObject, NSError>) -> Void = { (response: Response<AnyObject, NSError>) -> Void in
                    
                    #if DEBUG
                        debugPrint("<<<<<<<<<<<< Response")
                        debugPrint(response)
                        debugPrint(">>>>>>>>>>>> Response")
                    #endif
                    
                    var statusCode: Int = 200
                    if let nsResponse: NSHTTPURLResponse = response.response {
                        statusCode = nsResponse.statusCode
                    }
                    
                    let result: Result<AnyObject, NSError> = response.result
                    
                    if (result.isSuccess) {
                        if (result.value is [String: AnyObject]) {
                            do {
                                let value: T = try Unbox(result.value as! UnboxableDictionary)
                                if statusCode >= 200 && statusCode < 300 {
                                    completionBlock(unboxable: value)
                                } else {
                                    errorBlock(error: AlamofireError.statusCode, result: value)
                                }
                            } catch {
                                errorBlock(error: error, result: nil)
                            }
                        } else {
                            errorBlock(error: AlamofireError.invalidValue, result: nil)
                        }
                    } else if (result.isFailure) {
                        errorBlock(error: result.error, result: nil)
                    } else {
                        errorBlock(error: AlamofireError.network, result: nil)
                    }
                }
                
                let requestLog: Request = request.responseJSON(completionHandler: completionHandler)
                #if DEBUG
                    debugPrint("+++++++++++++++ Request")
                    debugPrint(requestLog)
                    debugPrint("--------------- Request")
                #endif
                break
            }
        }
        
        Alamofire.upload(method, URLString, headers: headers, multipartFormData: multipartFormData, encodingCompletion: completionHandler)
    }
}


