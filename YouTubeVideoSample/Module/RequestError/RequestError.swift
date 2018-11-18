//
//  RequestError.swift
//  YouTubeVideoSample
//
//  Created by Hasan on 11/17/18.
//  Copyright © 2018 Hasan. All rights reserved.
//

import UIKit
import SwiftyJSON

struct RequestError {
    
    var code: Int = -1
    var message: String?
    var error: Error?
    
    init(json: JSON) {
        if let error = json["error"].dictionary {
            if let value = error["code"]?.int {self.code = value}
            if let value = error["message"]?.string {self.message = value}
        }
    }
    
    init(error: Error) {
        self.error = error
    }
}
