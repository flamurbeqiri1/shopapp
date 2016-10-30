//
//  Categories+CoreDataProperties.swift
//  shopapp
//
//  Created by Flamur on 6/6/16.
//  Copyright © 2016 Codeators. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Categories {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?

}
