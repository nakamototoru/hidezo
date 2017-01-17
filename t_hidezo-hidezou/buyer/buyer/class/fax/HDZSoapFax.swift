//
//  HDZSoapFax.swift
//  pdfsample
//
//  Created by 庄俊亮 on 2017/01/08.
//  Copyright © 2017年 庄俊亮. All rights reserved.
//

import UIKit
//import AFNetworking

class HDZSoapFax: NSObject {
	
	// MARK: - 定数
	// MARK: アクセスアドレス
	static let theUrlString = "https://soap.faximo.jp/soapapi-sv/SoapServFS_1200.php"
	
	// MARK: XMLパーツ
	static let soapXmlFirst = "<?xml version='1.0' encoding='UTF-8'?><SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:ns1='urn:faximoAPI'>"
	static let soapXmlHeader = "<SOAP-ENV:Header><ns1:SOAPHeader><ns1:processkey>process_key</ns1:processkey><ns1:Attestation><ns1:userid>nakamoto</ns1:userid><ns1:password>ab123456</ns1:password></ns1:Attestation></ns1:SOAPHeader></SOAP-ENV:Header>"

	// MARK: - メソッド
	// MARK: リクエスト
	private class func request(soapMessage:String, completeBlock:(response:NSDictionary) -> Void, failureBlock:(error:NSError) -> Void) {
		
		let soapLenth = String(soapMessage.characters.count)

		let theURL = NSURL(string: theUrlString)
		let mutableR = NSMutableURLRequest(URL: theURL!)

		mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
		mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
		mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
		mutableR.HTTPMethod = "POST"
		mutableR.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding)

		// 3.AFNetworking Request
		let manager = AFHTTPRequestOperation(request: mutableR)
		manager.setCompletionBlockWithSuccess(
			{ (operation : AFHTTPRequestOperation, responseObject : AnyObject) -> Void in
			
				#if DEBUG
					debugPrint("**** HDZSoapFax:request:completeBlock ****")
				#endif
				
				var dictionaryData = NSDictionary()
				do {
					dictionaryData = try XMLReader.dictionaryForXMLData(responseObject as! NSData)
				
					#if DEBUG
						debugPrint(">>>> Response >>>>")
						debugPrint(dictionaryData)
						debugPrint(">>>> Response End >>>>")
					#endif
					
					completeBlock(response: dictionaryData)
					
				} catch {
					debugPrint("Your Dictionary value nil")
				}
				#if DEBUG
					debugPrint("**** HDZSoapFax:request:completeBlock END ****")
				#endif
			
			}, failure: { (operation : AFHTTPRequestOperation, error : NSError) -> Void in
				
				debugPrint(error, terminator: "ERROR:HDZSoapFax")
				
				failureBlock(error: error)
			}
		)
		manager.start()
	}
	
	// MARK: FAX送信
	internal class func requestDoSendRequest(base64Binary:String, telNumber:String, subject:String, completeHandler:(idxcnt:String,accepttime:String) -> Void, failHandler:(error:NSError) -> Void) {

		// FAX番号は数字のみ
		let numbers = telNumber.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
		var faxNumber = "" // "0666412100"
		for str:String in numbers {
			faxNumber += str
		}
		
		// XML
		var soapMessage = soapXmlFirst
		// Header
		soapMessage += soapXmlHeader
		// Body
		soapMessage += "<SOAP-ENV:Body><ns1:doSendRequest><FAXSendRequest><ns1:SendData>"
		soapMessage += "<ns1:sendto>"
		soapMessage += faxNumber
		soapMessage += "</ns1:sendto>"
		soapMessage += "<ns1:subject>"
		soapMessage += subject
		soapMessage += "</ns1:subject>"
//		soapMessage += "<ns1:userkey>1</ns1:userkey>"
//		soapMessage += "<ns1:tsid>1</ns1:tsid>"
//		soapMessage += "<ns1:headerinfo>1</ns1:headerinfo>"
//		soapMessage += "<ns1:retrynum>0</ns1:retrynum>"
//		soapMessage += "<ns1:resaddress>1</ns1:resaddress>"
//		soapMessage += "<ns1:body>body</ns1:body>"
		soapMessage += "<ns1:Attachment>"
		soapMessage += "<ns1:attachmentname>testpdf.pdf</ns1:attachmentname>"
		soapMessage += "<ns1:attachmentdata>"
		soapMessage += base64Binary
		soapMessage += "</ns1:attachmentdata>"
		soapMessage += "</ns1:Attachment>"
		soapMessage += "</ns1:SendData></FAXSendRequest></ns1:doSendRequest></SOAP-ENV:Body></SOAP-ENV:Envelope>"
		// END of XML

		let completeBlock:(response:NSDictionary) -> Void = { (response) in
			
			guard let soapEnvelope:NSDictionary = response.objectForKey("SOAP-ENV:Envelope") as? NSDictionary else {
				return
			}
			guard let soapBody:NSDictionary = soapEnvelope.objectForKey("SOAP-ENV:Body") as? NSDictionary else {
				return
			}

			guard let soapDoSendResponse:NSDictionary = soapBody.objectForKey("ns1:doSendRequestResponse") as? NSDictionary else {
				return
			}
			guard let soapFaxSendResponse:NSDictionary = soapDoSendResponse.objectForKey("FAXSendResponse") as? NSDictionary else {
				return
			}

			guard let soapSendDataResponse:NSDictionary = soapFaxSendResponse.objectForKey("ns1:SendDataResponse") as? NSDictionary else {
				return
			}

			var idxcnt = ""
			if let idxcntDict:NSDictionary = soapSendDataResponse["ns1:idxcnt"] as? NSDictionary {
				idxcnt = idxcntDict["text"] as! String
			}
			var accepttime = ""
			if let accepttimeDict:NSDictionary = soapSendDataResponse["ns1:accepttime"] as? NSDictionary {
				accepttime = accepttimeDict["text"] as! String
			}
			completeHandler(idxcnt: idxcnt, accepttime: accepttime)
		}
		let failureBlock:(error:NSError) -> Void = { (error) in
			failHandler(error: error)
		}
		request(soapMessage, completeBlock:completeBlock, failureBlock:failureBlock )
	}
	
	// MARK: 送信履歴取得
	internal class func requestGetSendList() {

		// XML
		var soapMessage = soapXmlFirst
		// Header
		soapMessage += soapXmlHeader
		// Body
		soapMessage += "<SOAP-ENV:Body><ns1:getSendList><FAXSendListRequest><ns1:SendListSearchCondition>"
		// 以降は任意
//		soapMessage += "<ns1:from>2016-12-01 00:00:00</ns1:from>"
//		soapMessage += "<ns1:to>2016-12-31 00:00:00</ns1:to>"
//		soapMessage += "<ns1:sendto>0489150077</ns1:sendto>"
//		soapMessage += "<ns1:userkey>userkey</ns1:userkey>"
//		soapMessage += "<ns1:accepttype>0</ns1:accepttype>" // 固定値
//		soapMessage += "<ns1:subject>testapi</ns1:subject>"
//		soapMessage += "<ns1:idxcnt>0001</ns1:idxcnt>"
//		soapMessage += "<ns1:status>0</ns1:status>"
//		soapMessage += "<ns1:maximumresponse>0</ns1:maximumresponse>" // 固定値
		soapMessage += "</ns1:SendListSearchCondition></FAXSendListRequest></ns1:getSendList></SOAP-ENV:Body></SOAP-ENV:Envelope>"
		// END of XML
	
		let completeBlock:(response:NSDictionary) -> Void = { (response) in
			
			guard let soapEnvelope:NSDictionary = response.objectForKey("SOAP-ENV:Envelope") as? NSDictionary else {
				return
			}
			guard let soapBody:NSDictionary = soapEnvelope.objectForKey("SOAP-ENV:Body") as? NSDictionary else {
				return
			}
			
			guard let soapGetSendListResponse:NSDictionary = soapBody.objectForKey("ns1:getSendListResponse") as? NSDictionary else {
				return
			}
			guard let soapFaxSendListResponse:NSDictionary = soapGetSendListResponse.objectForKey("FAXSendListResponse") as? NSDictionary else {
				return
			}
			
			guard let soapResult:NSDictionary = soapFaxSendListResponse.objectForKey("ns1:result") as? NSDictionary else {
				return
			}
			
			if soapResult.count > 0 {
				debugPrint(soapResult)
			}
		}
		let failureBlock:(error:NSError) -> Void = { (error) in
			//failHandler(error: error)
			debugPrint(error)
		}
		request(soapMessage, completeBlock:completeBlock, failureBlock: failureBlock)
	}

}
