//
//  Country+CoreDataProperties.swift
//  CoreDataProject
//
//  Created by Steven Gustason on 4/27/23.
//
//

import Foundation
import CoreData


extension Country {
    
    public var wrappedShortName: String {
        shortName ?? "Unknown Country"
    }

    public var wrappedFullName: String {
        fullName ?? "Unknown Country"
    }
    
    // Computed property that allows us to use this class with ForEach (because candy is an NSSet). In the end it converts our NSSet to a sorted [Candy]
    public var candyArray: [Candy] {
        // First, we create a variable to convert candy from an NSSet to a Set<Candy>
        let set = candy as? Set<Candy> ?? []
        // Then we sort this set by comparing two candy bars and returning true if the first should be sorted before the second. Sorting a set also returns an array, which is exactly what we want
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var shortName: String?
    @NSManaged public var candy: NSSet?

}

// MARK: Generated accessors for candy
extension Country {

    @objc(addCandyObject:)
    @NSManaged public func addToCandy(_ value: Candy)

    @objc(removeCandyObject:)
    @NSManaged public func removeFromCandy(_ value: Candy)

    @objc(addCandy:)
    @NSManaged public func addToCandy(_ values: NSSet)

    @objc(removeCandy:)
    @NSManaged public func removeFromCandy(_ values: NSSet)

}

extension Country : Identifiable {

}
