//
//  CloudKitManager.swift
//  RedAxe
//
//  Created by Max Vitruk on 8/9/16.
//  Copyright © 2016 ZealotSystem. All rights reserved.
//

import CloudKit

class CloudKitManager {
    let publicDB = CKContainer.defaultContainer().publicCloudDatabase
    
    func fetchTopicList(completion : (Topic)->Void){
        var themeCounter = 0
        let topic = Topic()
        let datePredicate = NSPredicate(format: "status = %d", 0)
        let query = CKQuery(recordType: "Topic", predicate: datePredicate)
        publicDB.performQuery(query, inZoneWithID: nil) { (records, error) in
            guard let fetchedRecords = records else {
                print("Could not fetch Topic list")
                return
            }
            
            guard fetchedRecords.count > 0 else {
                print("fetchedRecords.count < 0")
                return
            }
            
            let activeRecord = fetchedRecords[0]
            topic.author = activeRecord["author"] as? String
            topic.description = activeRecord["description"] as? String
            topic.expireDate = activeRecord["expireDate"] as? NSDate
            topic.channel = activeRecord["channel"] as? String
            topic.status = activeRecord["status"] as? Int
            topic.themes = [Themes]()
            
            let referenceList = activeRecord["themes"] as! [CKReference]
            
            themeCounter = referenceList.count
            
            for reference in referenceList {
                self.publicDB.fetchRecordWithID(reference.recordID) { fetchedPlace, error in
                    guard let fetchedPlace = fetchedPlace else {
                        print("Could not fetch Theme list")
                        return
                    }
                    
                    let theme = Themes()
                    theme.description = fetchedPlace["description"] as? String
                    theme.id = fetchedPlace["id"] as? Int
                    theme.rating = fetchedPlace["rating"] as? Int
                    theme.votesCount = fetchedPlace["votesCount"] as? Int
                    theme.votesLevel = fetchedPlace["votesLevel"] as? Int
                    topic.themes?.append(theme)
                    
                    themeCounter -= 1
                    
                    print(themeCounter)
                    print("Theme \(fetchedPlace["description"])")
                    
                    if themeCounter <= 0 {
                        let themes = topic.themes!
                        topic.themes = themes.sort({$0.id < $1.id})
                       completion(topic)
                    }
                    
                }
            }
        }
        
    }
}