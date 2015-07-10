//
//  Student.swift
//  StudentStatus
//
//  Created by Colin Moseley on 7/6/15.
//  Copyright © 2015 Colin Moseley. All rights reserved.
//

import Foundation
import CoreData

@objc(Student)
class Student: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func statusName(value: Int) -> String {
        let names = ["Fail", "Pass", "Honors"]
        let name: String = names[value]
        //print("Student.statusName for value of \(value) is \(name)")
        return name
    }
}
