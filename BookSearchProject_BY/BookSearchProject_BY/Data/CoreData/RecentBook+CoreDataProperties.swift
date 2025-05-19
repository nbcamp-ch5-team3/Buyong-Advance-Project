//
//  RecentBook+CoreDataProperties.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/14/25.
//
//

import Foundation
import CoreData


extension RecentBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentBook> {
        return NSFetchRequest<RecentBook>(entityName: "RecentBook")
    }

    @NSManaged public var thumbnailImage: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var authors: String?
    @NSManaged public var price: Int64
    @NSManaged public var contents: String?

}

extension RecentBook : Identifiable {

}
