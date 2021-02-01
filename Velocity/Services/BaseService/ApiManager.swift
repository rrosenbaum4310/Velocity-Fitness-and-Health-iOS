//
//  ApiManager.swift
//  LynkedWorld
//
//  Created by Macbook on 01/11/17.
//  Copyright © 2017 Arusys. All rights reserved.
//

import UIKit

class ApiManager: NSRestApiHelper {
    
    class var sharedManager: ApiManager {
        
        struct Singleton {
            static let instance = ApiManager()
        }
        return Singleton.instance
    }
    
    func cancelAllTasks() {
        self.cancelRequest()
    }
    
    func requestForGet(urlQuery:String,CompletionHandler completion: @escaping CompletionHandler){
        let dictHeader = self.getHeaderDictionary(token: "") //GlobalManager.sharedInstance.getAccessToken()
        self.getrequest(urlQuery: urlQuery, Headers: dictHeader) { (response, error) in
            if error == nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }

        }
    }
    
    func requestForPost(urlQuery: String, dictParam: NSDictionary, CompletionHandler completion: @escaping CompletionHandler) {
        let post = dictParam.convertDictionaryToStringNew()
        let postData:Data = post.data(using: String.Encoding.ascii)!
        let dictHeader = self.getHeaderDictionary(token: "") //GlobalManager.sharedInstance.getAccessToken()
        self.postRequest(urlQuery: urlQuery, Body: postData, Headers: dictHeader) { (response, error) in
            if error == nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func requestForPostWithImage(urlQuery: String, dictParam: NSDictionary, CompletionHandler completion: @escaping CompletionHandler) {
        let post = dictParam.convertDictionaryToStringNew()
        let postData:Data = post.data(using: String.Encoding.ascii)!
        let dictHeader = self.getHeaderDictionary(token: "") //GlobalManager.sharedInstance.getAccessToken()
        
        
        
        self.postRequest(urlQuery: urlQuery, Body: postData, Headers: dictHeader) { (response, error) in
            if error == nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func requestForPostWithArray(urlQuery: String, dictParam: [String: Any], CompletionHandler completion: @escaping CompletionHandler) {
        let dictHeader = self.getHeaderStringDictionary(token: "") //GlobalManager.sharedInstance.getAccessToken()
        self.postRequestWithArray(urlQuery: urlQuery, parameters: dictParam, Headers: dictHeader) { (response, error) in
            if error == nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func requestForPost(urlQuery: String, dictParam: String, CompletionHandler completion: @escaping CompletionHandler) {
        let post = dictParam //.convertDictionaryToStringNew()
        let postData:Data = post.data(using: String.Encoding.ascii)!
        let dictHeader = self.getHeaderDictionary(token: "") //GlobalManager.sharedInstance.getAccessToken()
        self.postRequest(urlQuery: urlQuery, Body: postData, Headers: dictHeader) { (response, error) in
            if error == nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func requestForPostwithMultipleImages(urlQuery: String, dictParam: NSDictionary, uploadImageArray multiImages: [String: Data], CompletionHandler completion: @escaping CompletionHandler) {
        let post = dictParam.convertDictionaryToStringNew()
        let postData:Data = post.data(using: String.Encoding.ascii)!
        let dictHeader = self.getHeaderDictionary(token: "") //GlobalManager.sharedInstance.getAccessToken()
        self.postRequestWithMultiImage(urlQuery: urlQuery, Body: postData, PostParameter: dictParam, Headers: dictHeader, uploadImageArray: multiImages)  { (response, error) in
            if error == nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func requestForPostWithMultipleMedia(urlQuery: String, dictParam: [String: String], uploadImageArray multiImages: [String: Data], CompletionHandler completion: @escaping CompletionHandler) {
//        let post = dictParam.convertDictionaryToStringNew()
//        let postData:Data = post.data(using: String.Encoding.ascii)!
        let dictHeader = self.getHeaderDictionary(token: "") //GlobalManager.sharedInstance.getAccessToken()
        self.requestWithImageUpload(urlQuery: urlQuery, parameters: dictParam, Headers: dictHeader, media: multiImages) { (response, error) in
            if error == nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
        
        
    }
    
    func requestForPostWithMultipleMedia(urlQuery: String, dictParam: [String: String], uploadImageArray multiImages: [String: [Data]], CompletionHandler completion: @escaping CompletionHandler) {
        //        let post = dictParam.convertDictionaryToStringNew()
        //        let postData:Data = post.data(using: String.Encoding.ascii)!
        let dictHeader = self.getHeaderDictionary(token: "") //GlobalManager.sharedInstance.getAccessToken()
        self.requestWithMultiImageUpload(urlQuery: urlQuery, parameters: dictParam, Headers: dictHeader, media: multiImages) { (response, error) in
            if error == nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
        
        
    }
    
    
    func requestPdfForPostWithMultipleMedia(urlQuery: String, dictParam: [String: String], uploadImageArray multiImages: [String: Data], CompletionHandler completion: @escaping CompletionHandler) {
        //        let post = dictParam.convertDictionaryToStringNew()
        //        let postData:Data = post.data(using: String.Encoding.ascii)!
        let dictHeader = self.getHeaderDictionary(token: "") //GlobalManager.sharedInstance.getAccessToken()
        self.requestWithPDfUpload(urlQuery: urlQuery, parameters: dictParam, Headers: dictHeader, media: multiImages) { (response, error) in
            if error == nil {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
        
        
    }
}
