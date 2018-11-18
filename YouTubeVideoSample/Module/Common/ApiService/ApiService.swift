//
//  ApiService.swift
//  YouTubeVideoSample
//
//  Created by Hasan on 11/17/18.
//  Copyright © 2018 Hasan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

fileprivate let API_URL = "https://www.googleapis.com/youtube/v3"
fileprivate let API_KEY = "AIzaSyAKYxf9GFeU3aBpD_RHa__1KNZDui0fZO8"
fileprivate let CHANNEL_ID = "UCbTw29mcP12YlTt1EpUaVJw"

protocol ApiServiceProtocol {
    typealias Parameters = [String : AnyObject]?
    typealias ResponseData = ((JSON?, RequestError?) -> Void)
    
    // Request Api's
    func requestVideos(numberOfItems: Int, completion: @escaping ResponseData)
    func requestSearch(searchParameter: String, numberOfItems: Int, completion: @escaping ResponseData)
}

private enum Endpoint: String {
    case video = "/videos"
    case search = "/search"
}

class ApiService: NSObject, ApiServiceProtocol {
    
    //MARK: Singleton
    
    let defaultManager: Alamofire.SessionManager =
    {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [API_URL: ServerTrustPolicy.pinCertificates(
            certificates: ServerTrustPolicy.certificates(in: Bundle.main),
            validateCertificateChain: true,
            validateHost: true
            ),
                                                                "insecure.expired-apis.com": .disableEvaluation
        ]
        
        var sessionManager = Alamofire.SessionManager()
        
        let configuration = URLSessionConfiguration.default
        sessionManager = Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        
        return sessionManager
    }()
    
    
    static let shared = ApiService()
}


// MARK: Public

extension ApiService {
    
    func requestVideos(numberOfItems: Int, completion: @escaping ResponseData) {
        let parameters = ["part": "snippet", "chart": "mostPopular", "maxResults": numberOfItems, "key": API_KEY] as [String : Any]
        GET(endpoint: Endpoint.video.rawValue, parameters: parameters, completion: completion)
    }
    
    func requestSearch(searchParameter: String, numberOfItems: Int, completion: @escaping ResponseData) {
        let parameters = ["part": "snippet", "q": searchParameter, "type": "video", "maxResults": numberOfItems, "key": API_KEY] as [String : Any]
        GET(endpoint: Endpoint.search.rawValue, parameters: parameters, completion: completion)
    }
}


// MARK: Private

extension ApiService {
    
    // GET
    fileprivate func GET(endpoint: String, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping ResponseData) {
        request(method: .get, endpoint: endpoint, parameters: parameters, headers: headers, completion: completion)
    }
    
    
    // Request common API
    fileprivate func request(method: HTTPMethod, endpoint: String, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, completion: @escaping ResponseData) {
        
        let urlString = API_URL+endpoint
        
        self.defaultManager.request(urlString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { responseData in
            
            switch (responseData.result)
            {
            case .success(let value):
                let responseJson = JSON(value)
                if let statusCode = responseData.response?.statusCode, statusCode == 200 {
                    print("JSON: \(responseJson)")
                    
                    completion(responseJson, nil)
                } else {
                    print("ERROR: \(value)")
                    
                    completion(nil, RequestError(json: value as! JSON))
                }
            case .failure(let error):
                print("ERROR: \(error)")
                completion(nil, RequestError(error: error))
            }
        }
    }
}
