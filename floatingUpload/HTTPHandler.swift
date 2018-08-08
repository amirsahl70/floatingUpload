//
//  HTTPHandler.swift
//  jsonPractice
//
//  Created by Amir on 7/14/2016.
//  Copyright © 2018 uni. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HttpHandler{
    
    static func upload(serverPath : URL?, libraryPath :URL?, index: IndexPath, sessionManager:SessionManager, completionHandler : @escaping ( SessionManager.MultipartFormDataEncodingResult, URL, IndexPath) -> Void  ){
        sessionManager.upload( multipartFormData: { multipartFormData in
            multipartFormData.append(libraryPath!, withName: "file")
        },
        to: serverPath! , 
        encodingCompletion: { (encodingResult) in
            completionHandler(encodingResult, libraryPath!, index)
        })
        
        certificate.SSLPinning(sessionManager: sessionManager)
        
    }
}

