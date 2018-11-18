//
//  VideoObject.swift
//  YouTubeVideoSample
//
//  Created by Hasan on 11/17/18.
//  Copyright © 2018 Hasan. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

enum Thumbnails {
    case thdefault, medium, standart, max, high
}

class VideoObject: Object {
    
    @objc dynamic private(set) var id: String!
    @objc dynamic private(set) var title: String!
    @objc dynamic private(set) var thumbnailDefaultUrlString: String?
    @objc dynamic private(set) var thumbnailMediumUrlString: String?
    @objc dynamic private(set) var thumbnailStandartUrlString: String?
    @objc dynamic private(set) var thumbnailMaxUrlString: String?
    @objc dynamic private(set) var thumbnailHighUrlString: String?

    convenience init(json: JSON) {
        self.init()
        
        if let value = json["id"].string {
            self.id = value
        } else if let value = json["id"].dictionary {
            self.id = value["videoId"]?.string
        }
        if let value = json["snippet"]["title"].string {self.title = value}
        if let value = json["snippet"]["thumbnails"].dictionary {
            if let value = value["medium"]?.dictionary {
                self.thumbnailMediumUrlString = value["url"]?.string
            }
            if let value = value["high"]?.dictionary {
                self.thumbnailHighUrlString = value["url"]?.string
            }
            if let value = value["standard"]?.dictionary {
                self.thumbnailStandartUrlString = value["url"]?.string
            }
            if let value = value["default"]?.dictionary {
                self.thumbnailDefaultUrlString = value["url"]?.string
            }
            if let value = value["maxres"]?.dictionary {
                self.thumbnailMaxUrlString = value["url"]?.string
            }
        }
    }
    
    func thumbnailImageUrlString(resolution: Thumbnails = .thdefault) -> String? {
        switch resolution {
        case .medium:
            return thumbnailMediumUrlString ?? ""
        case .standart:
            return thumbnailStandartUrlString ?? ""
        case .max:
            return thumbnailMaxUrlString ?? ""
        case .high:
            return thumbnailHighUrlString ?? ""
        default:
            return thumbnailDefaultUrlString ?? ""
        }
    }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
