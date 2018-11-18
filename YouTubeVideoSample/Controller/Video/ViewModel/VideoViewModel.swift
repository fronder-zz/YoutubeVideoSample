//
//  VideoViewModel.swift
//  YouTubeVideoSample
//
//  Created by Hasan on 11/17/18.
//  Copyright © 2018 Hasan. All rights reserved.
//

import UIKit
import RealmSwift

class VideoViewModel: NSObject {
    
    // MARK: Variables
    
    var items = [VideoObject]()
    var didUpdateData: () -> () = {}
    var dataLoaded = false
    
    fileprivate var maxNumber = 0
    
    
    // MARK: Init

    override init() {
        super.init()
        
        self.items = getStoredItems()
        self.didUpdateData()
        
        fetchVideos(clear: true)
    }
    
    
    // MARK: Public
    // Fetch
    func fetchVideos(clear: Bool) {
        if clear {
            maxNumber = 0
            DatabaseManager.shared.deleteAll()
        }
        
        if maxNumber >= 50 { // This is done because there are 50 items max allowed to fetch from API
            return
        }
        
        maxNumber += 10
        ApiService.shared.requestVideos(numberOfItems: maxNumber) { (json, error) in
            if let array = json?["items"].array {
                if clear {
                    self.items.removeAll()
                }
                array.forEach({ [weak self] (json) in
                    let object = DatabaseManager.shared.insertUserData(json: json)
                    self?.items.append(object)
                })
            }
            onMain { [weak self] in
                self?.didUpdateData()
            }
            
            self.dataLoaded = true
        }
    }
    
    
    func fetchSearch(searchParameter: String, clear: Bool) {
        if clear {
            maxNumber = 0
            DatabaseManager.shared.deleteAll()
        }
        
        if maxNumber >= 50 { // This is done because there are 50 items max allowed to fetch from API
            return
        }
        
        maxNumber += 10
        ApiService.shared.requestSearch(searchParameter: searchParameter, numberOfItems: maxNumber) { (json, error) in
            if let array = json?["items"].array {
                if clear {
                    self.items.removeAll()
                }
                array.forEach({ [weak self] (json) in
                    let object = DatabaseManager.shared.insertUserData(json: json)
                    self?.items.append(object)
                })
                onMain { [weak self] in
                    self?.didUpdateData()
                }
            }
        }
    }
    
    
    func count() -> Int {
        return items.count
    }
    
    
    // MARK: Private
    
    fileprivate func getStoredItems() -> [VideoObject] {
        var items = [VideoObject]()
        if let result = DatabaseManager.shared.getVideoObjects(), result.count > 0 {
            items = Array(result)
        }
        return items
    }
}
