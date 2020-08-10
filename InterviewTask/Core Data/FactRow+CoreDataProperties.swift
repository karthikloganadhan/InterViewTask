//
//  FactRow+CoreDataProperties.swift
//  InterviewTask
//
//  Created by Admin on 09/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//
//

import Foundation
import CoreData


extension FactRow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FactRow> {
        return NSFetchRequest<FactRow>(entityName: "FactRow")
    }

    @NSManaged public var descriptionstring: String?
    @NSManaged public var image: Data?
    @NSManaged public var imagePath: String?
    @NSManaged public var isImageAvailable: Bool
    @NSManaged public var titlestring: String?
    @NSManaged public var forCountry: Country?

}
