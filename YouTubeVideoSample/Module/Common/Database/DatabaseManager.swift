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
    
    
    // MARK: Public
    // MARK: INSERT
    
    func insertVideoObject(json: JSON) -> VideoObject {
        let object = VideoObject(json: json)
        updateToRealm(object: object)
        
        return object
    }
    
    
    // MARK: GET
    
    func getVideoObjects() -> Results<VideoObject>? {
        let realm = try! Realm()
        return realm.objects(VideoObject.self)
    }
}


// MARK: CRUD API

extension DatabaseManager {
    
    func saveToRealm(object: Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    
    func updateToRealm(object: Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(object, update: true)
        }
    }
    
    func updateRealmObject(block:() -> ()) {
        let realm = try! Realm()
        try! realm.write {
            block()
        }
    }
    
    func delete(object: Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func deleteRealmObjectList(objects: Results<Object>) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(objects)
        }
    }
    
    func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
