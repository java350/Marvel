//
//  RealmManager.swift
//  SearchGiphy
//
//  Created by Volodymyr.
//  Copyright © 2019 java. All rights reserved.
//

import RealmSwift

class RealmManager {
    
    // MARK: -
    // MARK:  Properties
    
    private var realm: Realm
    static let instance = RealmManager()
    

    // MARK:  Initializations
    
    private init() {
        let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in })
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()
    }
    
    
    // MARK:  Public methods
    
    func allObjects<T:Object>(_ type: T.Type) -> Results<T> {
        let results: Results<T> = realm.objects(type)
        
        return results
    }
    
    func add<T:Object>(object: T, handler: (()->())? = nil)   {
        try! realm.write {
            realm.add(object) //, update: true)
            handler?()
        }
    }
    
    func deleteAllObjects()  {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func delete<T:Object>(object: T)   {
        try! realm.write {
            realm.delete(object)
        }
    }
}
