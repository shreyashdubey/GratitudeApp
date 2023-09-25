//
//  APIService.swift
//  Gratitude
//
//  Created by Shreyash Dubey on 9/23/23.
//

import Foundation
import SwiftUI

struct APICallStatusModel {
    var requestID: String
    var callURL : String
    var timeOfCall: Date
}

struct APIRetryModel{
    var request: APICall
    var wasRetried: Bool
    var retryCount: Int
}

struct APICall {
    var callURl: String, parameters: Any = [String:String](), customHeader: [String:String]? =  nil, httpMethod: HTTPMethod = .post, accessToken: String = "", showLoader: Bool = true, forceRetry: Bool = true, completionHandler: (_ jsonResponse: String?, _ reponseError: Bool, _ errorMessage: String) -> ()
}


enum HTTPMethod: String {
    case get = "GET", post = "POST", delete = "DELETE", patch = "PATCH"
}

final class APIService{
    
    private static let sharedAPIService: APIService = {
        return APIService()
    }()
    
    
    class func shared() -> APIService {
        return sharedAPIService
    }
    
    lazy var sessionManager: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        return URLSession(configuration: configuration, delegate: NetworkSessionHandler(), delegateQueue: .main)
    }()
    
    lazy var sessionManagerWithoutTimeout: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.allowsExpensiveNetworkAccess = true
        configuration.allowsConstrainedNetworkAccess = true
        configuration.allowsCellularAccess = true
        return URLSession(configuration: configuration, delegate: NetworkSessionHandler(), delegateQueue: .main)
    }()
    
    
    lazy var apiRequestLog = [APICallStatusModel]()
    
    
    lazy var apiRetryCallLog = [APIRetryModel]()
    
    static var imageCache = NSCache<AnyObject, AnyObject>()
    
    static func callImageAPI(_ imageUrl: String, resultHandler: @escaping (_ data: Data?) -> ()) -> () {
    }
    
    enum DownloadError: Error {
        case badImage
        case unknown
        case invalidStatusCode
    }
    
    
    func downloadFileFrom(url: String, responseHandler: @escaping (Data?) -> ()) {
        print("downloadFileFromURL", url)
        if let url = URL(string: url){
            APIService.shared().sessionManager.dataTask(with: url) { data, urlResponse, error in
                print("downloadedFileFrom", url)
                print("downloadedFiledata", data)
                if (error == nil && data != Data()), let fileData = data {
                    responseHandler(data)
                    return
                }else{
                    responseHandler(nil)
                }
            }.resume()
        }else{
            responseHandler(nil)
            print("downloadFileFrom-failed", url)
        }
    }
    
    
    func downloadImageWith(url: String, task: String)  async throws -> UIImage {
        let imageUrl = URL(string: url)!
        let imageRequest = URLRequest(url: imageUrl)
        print("startedTask", task)
        let (data, response) = try await URLSession.shared.data(for: imageRequest)
            print("finishedTask:",task)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw DownloadError.invalidStatusCode
        }
        
        guard let image = UIImage(data: data) else {
            throw DownloadError.badImage
        }
        
        return image
    }
    
    static func downloadImage(from urlString: String, imageResponseHandler: @escaping (UIImage?) -> ()) {
        
        if let url = URL(string: urlString){
            if let imageData = APIService.imageCache.object(forKey: url as AnyObject), let image = imageData as? UIImage{
                imageResponseHandler(image)
            }else{
                APIService.shared().sessionManager.dataTask(with: url) { data, urlResponse, error in
                    if (error == nil && data != nil && data != Data()), let imageData = data {
                        if UIImage(data: imageData, scale:1) != nil {
                            let image = UIImage(data: imageData, scale:1)  ?? UIImage()
                            
                            APIService.imageCache.setObject(image, forKey: url as AnyObject)
                            
                            imageResponseHandler(image)
                        }
                    }else{
                        imageResponseHandler(UIImage())
                    }
                }.resume()
            }
        }else{
            imageResponseHandler(UIImage())
        }
    }
    
    
    func callAPI(callURl: String, parameters: Any = [String:String](), customHeader: [String:String]? =  nil, httpMethod: HTTPMethod = .post, accessToken: String = "", showLoader: Bool = true, forceRetry: Bool = true,  completionHandler: @escaping (_ jsonResponse: String?, _ reponseError: Bool, _ errorMessage: String) -> ()) {
        
        print("ReachabilityManager", ReachabilityManager.isConnectedToNetwork())
        if !ReachabilityManager.isConnectedToNetwork(){
            if forceRetry{
                let apiCallRequest = APICall(callURl: callURl, parameters: parameters, customHeader: customHeader, httpMethod: httpMethod, accessToken: accessToken, showLoader: showLoader, forceRetry: forceRetry,completionHandler: completionHandler)
                APIService.shared().apiRetryCallLog.append(APIRetryModel(request: apiCallRequest, wasRetried: false, retryCount: 0))
            }else{
                DispatchQueue.main.async {
                    completionHandler(nil, false , "Your device has lost it's internet connection")
                }
            }
        }else{
            let requestID = String.randomAlphanumericString(length: 4)
            
            if showLoader{
                let requestItemForLog = APICallStatusModel(requestID: requestID, callURL: callURl, timeOfCall: Date())
                toggleSpinner(isAnimating: true, requestID: requestID, requestItemForLog: requestItemForLog)
            }
            
            guard let _ = URL(string: callURl) else {
                DispatchQueue.main.async {
                    completionHandler(nil, false , "Invalid URL")
                }
                return
            }
            
            var jsonParameters = ""
            
            jsonParameters = APIService.convertToJsonString(parameters: parameters)
            
            var headers = [String:String]()
            if customHeader != nil{
                headers = customHeader!
            }else{
                headers = APIService.getHeaders(accessToken: accessToken)
            }
            
            print("APIService-URl: ", callURl)
            print("APIService-Headers", headers)
            print("APIService-Parameters", parameters)
            
            
            let request = APIService.createRequest(apiURL: callURl, headers: headers, parameters: jsonParameters, httpMethod: httpMethod)
            // [weak self]
            APIService.shared().sessionManager.dataTask(with: request) { (responseData, httpResponse, error) in
                print("APIService-ResponseForAPIURL: ", callURl)
                DispatchQueue.main.async {
                    
                    
                    if(error == nil && responseData != nil)
                    {
                        let responseString = String(decoding: responseData!, as: UTF8.self)
                        print("Response-For-responseString: ", responseString)
                        
                        DispatchQueue.main.async {
                            completionHandler(responseString, false ,"")
                        }
                        
                    }else{
                        //DISPLAY ERROR ALERT
                        // print("URLSession-Responseerror", error)
                        //completionHandler(nil, "", true , "Response Received")
                    }
                    if showLoader{
                        APIService.shared().toggleSpinner(isAnimating: false, requestID: requestID)
                    }
                }
            }.resume()
        }
    }
    
    
    private func toggleSpinner(isAnimating: Bool, requestID: String, requestItemForLog: APICallStatusModel? = nil){
        if isAnimating{
            if var requestItemForLog = requestItemForLog{
                var requestID = requestID
                while APIService.shared().apiRequestLog.contains(where: {$0.requestID == requestID}) {
                    requestID = String.randomAlphanumericString(length: 4)
                }
                requestItemForLog.requestID = requestID
                APIService.shared().apiRequestLog.append(requestItemForLog)
            }
            
            // print("self.apiRequestLog1",self.apiRequestLog)
            // print( "SpinnerStarted")
            //  CustomLoader.startSpinner()
        }else{
            if let index = APIService.shared().apiRequestLog.firstIndex(where: {$0.requestID == requestID}) {
                APIService.shared().apiRequestLog.remove(at: index)
            }
            
            let validRequest = APIService.shared().apiRequestLog.filter({Date().seconds(from: $0.timeOfCall) < 150 })
            APIService.shared().apiRequestLog = validRequest
            
            if APIService.shared().apiRequestLog.count==0 {
                // print( "SpinnerStopeped")
                // CustomLoader.stopSpinner()
            }else{
                // print("self.apiRequestLog",self.apiRequestLog)
                // print("UnableToStopSpinner")
            }
        }
    }
    
    
    static func createRequest(apiURL: String, headers: [String:String], parameters: String = "", httpMethod: HTTPMethod) ->  URLRequest{
        
        var request = URLRequest(url: URL(string: apiURL)!,timeoutInterval: Double.infinity)
        
        headers.forEach { header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        if parameters != ""{
            let postData = parameters.data(using: .utf8)
            request.httpBody = postData
        }
        
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
    
    static func getHeaders(contentType: String = "application/json", accessToken : String = "") -> [String:String] {
        var headers =
        ["api-key" : "aQme71D1AC9KLUqAhrZ",
         "Content-Type": contentType]
        
        //TODO: 
//        if AppUtils.fetchAccessToken() != ""{
//            headers["access-token"] = ""//AppUtils.fetchAccessToken()
//        }
//
//        if let accessToken = AppUtils.fetchUserData()?.accessToken{
//            if accessToken != ""{
//                headers["access-token"] = accessToken
//            }
//        }
        
        if accessToken != ""{
            headers["access-token"] = accessToken
        }
        return headers
    }
    
    
    static func convertToJsonString(parameters: Any = [String:Any]()) -> String{
        let jsonParamters = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonParamters, encoding: .utf8)!
        
        if jsonString != ""{
            let prettyPrintedJsonString = String(data: jsonParamters, encoding: .utf8)!
            print("JSON_STRING\n\(prettyPrintedJsonString) ________________" )
        }else{
            print("JSONSerialization FAILED")
        }
        return jsonString
    }
    
    
    /*
     //Usage:
     if let modelObj = APIService.decode(ModelName.self, from: jsonString){
     }
     */
    static func decode<T: Decodable>(_ type: T.Type, from jsonString: String) -> T? {
        if let data = jsonString.data(using: .utf8) {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            
            return nil
        }
        return nil
    }
    
}













//extension APIService: FullScreenAlertVCDelegate{
//    func didTapOnPrimaryButton(button: UIButton, alertVC: FullScreenAlertVC?) {
//        for (index,apiCall) in APIService.shared().apiRetryCallLog.enumerated(){
//            APIService.shared().callAPI(callURl: apiCall.request.callURl,
//                                        parameters: apiCall.request.parameters,
//                                        encryptParameters: apiCall.request.encryptParameters,
//                                        customHeader: apiCall.request.customHeader,
//                                        httpMethod: apiCall.request.httpMethod,
//                                        defaultToken: apiCall.request.defaultToken,
//                                        showLoader: apiCall.request.showLoader,
//                                        forceRetry: apiCall.request.forceRetry,
//                                        completionHandler: apiCall.request.completionHandler)
//
//            APIService.shared().apiRetryCallLog[index].wasRetried = true
//            APIService.shared().apiRetryCallLog[index].retryCount = APIService.shared().apiRetryCallLog[index].retryCount + 1
//        }
//        APIService.shared().apiRetryCallLog.removeAll(where: {$0.wasRetried == true})
//    }
//
//    func didTapOnSecondaryButton(button: UIButton, alertVC: FullScreenAlertVC?) {
//
//    }
//}






/*
 switch httpResponse.statusCode {
         case 200...299:
             return .success(data)
         case 400...499:
             return .failure(APIError.badRequest)
         case 500...599:
             return .failure(APIError.serverError)
         default:
             return .failure(APIError.unknown)
 }
 */
