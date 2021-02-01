//
//  NSRestApiHelper.swift
//  LynkedWorld
//
//  Created by Macbook on 01/11/17.
//  Copyright © 2017 Arusys. All rights reserved.
//

import UIKit
import Alamofire

// MARK:- Type alias defines
typealias CompletionHandler = (_ obj: AnyObject?, _ error: Error?) -> Void

class NSRestApiHelper: NSObject {

    override init () {
        super.init()
    }
    //Base url
    var baseURL: String = SERVERURL.mainBaseAPIPath //MAIN_URL
    
    //service URL property
    var serviceURL: String = String() {
        didSet {
            self.serviceURL = self.baseURL + serviceURL
        }
    }
    
    func getrequest(urlQuery: String,Headers headers: NSDictionary,CompletionHandler completion:@escaping CompletionHandler){
        serviceURL = urlQuery
        var request: URLRequest = self.getRequestUrlForPath(headers: headers)
        request.httpMethod = HTTPMethod.get.rawValue
        self.sendRequest(request: request, CompletionHandler: completion)
    }

    //MARK:- Post Request
    func postRequest(urlQuery: String, Body body: Data, Headers headers: NSDictionary, CompletionHandler completion:@escaping CompletionHandler) {
        serviceURL = urlQuery
        var request: URLRequest = self.getRequestUrlForPath(headers: headers)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = body
        request.timeoutInterval = 60.0
        self.sendRequest(request: request, CompletionHandler: completion)
    }
    
    
    func postRequestWithArray(urlQuery: String, parameters param: [String: Any], Headers headers: [String: String], CompletionHandler completion:@escaping CompletionHandler) {
        serviceURL = urlQuery
        let url = URL(string: serviceURL)
        
        Alamofire.request(url!, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            if let statusCode = response.response?.statusCode {
                if statusCode == 410 {
                    //appDelegate.appTokeExpiredReloadLogin()
                   // appDelegate.deleteAccountDetected()
                    return
                }
            }
            switch response.result {
            case .success:
                print(response)
                completion(response.result.value! as AnyObject, nil)
                break
            case .failure(let error):
                completion(nil, error)
                print(error)
            }
        }
        
    }
    
    func requestWithImageUpload(urlQuery: String, parameters param: [String: String] , Headers headers: NSDictionary, media mediaParam: [String: Data], CompletionHandler completion:@escaping CompletionHandler) {
        
        serviceURL = urlQuery
        var request: URLRequest = self.getRequestUrlForPath(headers: headers)
        request.httpMethod = HTTPMethod.post.rawValue
        //request.httpBody = body
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let newImgName:String =  Date().convertIntoTimeStampMilies() + ".jpg"
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            for (key, value) in mediaParam {
                multipartFormData.append(value, withName: key ,fileName: newImgName, mimeType: "image/jpg")
            }
            
           
        }, with: request) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value ?? "")
                    switch response.result {
                    case .success(_):
                        if response.result.value != nil {
                            print(response.result.value as Any)
                            completion(response.result.value! as AnyObject, nil)
                        }
                        break
                    case .failure(_):
                        completion(nil, response.result.error!)
                        break
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                
//                if (encodingError as NSError).code == -1009 {
//                    if let message = encodingError?.localizedDescription {
//                        appDelegate.showAlerMessage(message: message)
//                    }
//                }
                
                completion(nil, encodingError)
            }
        }
    }
    
    func requestWithMultiImageUpload(urlQuery: String, parameters param: [String: String] , Headers headers: NSDictionary, media mediaParam: [String: [Data]], CompletionHandler completion:@escaping CompletionHandler) {
        
        serviceURL = urlQuery
        var request: URLRequest = self.getRequestUrlForPath(headers: headers)
        request.httpMethod = HTTPMethod.post.rawValue
        //request.httpBody = body
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let newImgName:String =  Date().convertIntoTimeStampMilies() + ".jpg"
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            for (key, value) in mediaParam {
                for dataVal in value {
                    multipartFormData.append(dataVal, withName: key ,fileName: newImgName, mimeType: "image/jpg")
                }
            }
            
            
        }, with: request) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value ?? "")
                    switch response.result {
                    case .success(_):
                        if response.result.value != nil {
                            print(response.result.value as Any)
                            completion(response.result.value! as AnyObject, nil)
                        }
                        break
                    case .failure(_):
                        completion(nil, response.result.error!)
                        break
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                
                //                if (encodingError as NSError).code == -1009 {
                //                    if let message = encodingError?.localizedDescription {
                //                        appDelegate.showAlerMessage(message: message)
                //                    }
                //                }
                
                completion(nil, encodingError)
            }
        }
    }
    
    
    
    func requestWithPDfUpload(urlQuery: String, parameters param: [String: String] , Headers headers: NSDictionary, media mediaParam: [String: Data], CompletionHandler completion:@escaping CompletionHandler) {
        
        serviceURL = urlQuery
        var request: URLRequest = self.getRequestUrlForPath(headers: headers)
        request.httpMethod = HTTPMethod.post.rawValue
        //request.httpBody = body
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let newImgName:String =  Date().convertIntoTimeStampMilies() + ".pdf"
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            for (key, value) in mediaParam {
                multipartFormData.append(value, withName: key ,fileName: newImgName, mimeType: "application/pdf")
            }
            
            
        }, with: request) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value ?? "")
                    switch response.result {
                    case .success(_):
                        if response.result.value != nil {
                            print(response.result.value as Any)
                            completion(response.result.value! as AnyObject, nil)
                        }
                        break
                    case .failure(_):
                        completion(nil, response.result.error!)
                        break
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                completion(nil, encodingError)
            }
        }
    }
    
    
    
    
    //MARK:- Post Request With Multiple Image
    func postRequestWithMultiImage(urlQuery: String,Body body: Data, PostParameter postParams:NSDictionary , Headers headers: NSDictionary, uploadImageArray multiImages: [String: Data], CompletionHandler completion:@escaping CompletionHandler) {
        serviceURL = urlQuery
        var request: URLRequest = self.getRequestUrlForPath(headers: headers)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = body
        let boundary = generateBoundaryString()
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBodyWithMultiImageParameters(postParams, uploadImageArray: multiImages, boundary: boundary)
        self.sendRequest(request: request, CompletionHandler: completion)
    }
    
    //MARK:- Generate Boundary And MultiImage parameter for Image Upload
    private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    private func createBodyWithMultiImageParameters(_ parameters: NSDictionary, uploadImageArray multiImages: [String: Data], boundary: String) -> Data {
        var body = Data();
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        for (key, value) in multiImages {
            let filename = "\(key).jpg"
            let mimetype = "image/jpg"
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(value)
            body.append("\r\n")
            body.append("--\(boundary)--\r\n")
        }
        return body as Data
    }
    
    //MARK:- GetRequestMethods
    private func getRequestUrlForPath(headers: NSDictionary) -> URLRequest {
        let fullUrl = serviceURL
        let url = URL(string: fullUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        request.timeoutInterval = 30.0
        for (key, value) in headers {
            request.addValue((value as? String)!, forHTTPHeaderField: key as! String)
        }
        return request
    }
    
    //MARK: Header Parameters
    func getHeaderDictionary(token atoken:String) -> NSDictionary{
        let dicData = NSMutableDictionary()
        if atoken.count > 0 {
            dicData["Token"] = atoken
        }
        return dicData
    }
    
    func getHeaderStringDictionary(token atoken:String) -> [String: String]{
        var dicData = [String:String]()
        if atoken.count > 0 {
            dicData["Token"] = atoken
        }
        return dicData
    }
    
    //MARK:- Send Request To Server
    private func sendRequest(request: URLRequest, CompletionHandler completionHandler:@escaping CompletionHandler) {
        let urlRequest = request
        Alamofire.request(urlRequest).debugLog().responseJSON()  { response in
            if let statusCode = response.response?.statusCode {
                if statusCode == 410 {
                    //appDelegate.appTokeExpiredReloadLogin()
                   // appDelegate.deleteAccountDetected()
                    return
                }
            }
            switch response.result {
            case .success(_):
                debugPrint(response.result.value ?? "")
                if response.result.value != nil {
                    //print(response.result.value as Any)
                    completionHandler(response.result.value! as AnyObject, nil)
                }
                break
            case .failure(_):
                completionHandler(nil, response.result.error!)
                break
            }
        }
    }
    
    func cancelRequest() {
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getAllTasks { (dataTask) in
            dataTask.forEach { $0.cancel() }
        }
    }
    
    
}

extension NSDictionary {
    func convertDictionaryToStringNew() -> String {
        var paramString = ""
        for (key, value) in self {
            let strTemp = (paramString.count > 0) ? "&\(key)=\(value)" : "\(key)=\(value)"
            paramString = paramString.appendingFormat(strTemp)
        }
        return paramString
    }
}
extension Data {
    mutating func append(_ string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
}
