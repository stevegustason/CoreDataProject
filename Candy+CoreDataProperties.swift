//
//  Candy+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Steven Gustason on 4/27/23.
//
//

import Foundation
import CoreData


extension Candy {
    
    public var wrappedName: String {
        name ?? "Unknown Candy"
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Candy> {
        return NSFetchRequest<Candy>(entityName: "Candy")
    }

    @NSManaged public var name: String?
    @NSManaged public var origin: Country?

}

extension Candy : Identifiable {

}
