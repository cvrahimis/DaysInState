//
//  Locations+CoreDataProperties.swift
//  DaysInState
//
//  Created by Costas Vrahimis on 6/1/16.
//  Copyright © 2016 Costas Vrahimis. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Locations {

    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var state: String?
    @NSManaged var zip: String?
    @NSManaged var user: User?

}
