//
//  SavedBook+CoreDataProperties.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/13/25.
//
//

import Foundation
import CoreData


extension SavedBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedBook> {
        return NSFetchRequest<SavedBook>(entityName: "SavedBook")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var price: Int64
    @NSManaged public var createdAt: Date?
    @NSManaged public var thumbnailImage: String?
    @NSManaged public var contents: String?

}

extension SavedBook : Identifiable {

}
