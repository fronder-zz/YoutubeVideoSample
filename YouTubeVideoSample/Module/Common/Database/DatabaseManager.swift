//
//  DatabaseManager.swift
//  YouTubeVideoSample
//
//  Created by Hasan on 11/18/18.
//  Copyright © 2018 Hasan. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class DatabaseManager: NSObject {

    static let shared = DatabaseManager()
    var realm = try! Realm()
    
    
    // MARK: Public
    // MARK: INSERT
    
    func insertUserData(json: JSON) -> VideoObject {
        let object = VideoObject(json: json)
        saveToRealm(object: object)
        
        return object
    }
    
    
    // MARK: GET
    
    func getVideoObjects() -> Results<VideoObject>? {
        return realm.objects(VideoObject.self)
    }
}


// MARK: CRUD API

extension DatabaseManager {
    
    func saveToRealm(object: Object) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    func updateRealmObject(block:() -> ()) {
        try! realm.write {
            block()
        }
    }
    
    func delete(object: Object) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func deleteRealmObjectList(objects: Results<Object>) {
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
