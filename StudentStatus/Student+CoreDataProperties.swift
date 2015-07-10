//
//  Student+CoreDataProperties.swift
//  StudentStatus
//
//  Created by Colin Moseley on 7/6/15.
//  Copyright © 2015 Colin Moseley. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Student {

    @NSManaged var status: NSNumber?
    @NSManaged var name: String?

}
