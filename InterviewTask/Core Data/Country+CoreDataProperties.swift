//
//  Country+CoreDataProperties.swift
//  InterviewTask
//
//  Created by Balachandar M on 08/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var titleString: String?
    @NSManaged public var eachRow: NSSet?

}

// MARK: Generated accessors for eachRow
extension Country {

    @objc(addEachRowObject:)
    @NSManaged public func addToEachRow(_ value: FactRow)

    @objc(removeEachRowObject:)
    @NSManaged public func removeFromEachRow(_ value: FactRow)

    @objc(addEachRow:)
    @NSManaged public func addToEachRow(_ values: NSSet)

    @objc(removeEachRow:)
    @NSManaged public func removeFromEachRow(_ values: NSSet)

}
