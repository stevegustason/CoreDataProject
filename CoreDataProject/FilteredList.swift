//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Steven Gustason on 4/27/23.
//

import CoreData
import SwiftUI

/*
// Original filtered list, specific to the lastname property of the singer entity
struct FilteredList: View {
    // Property to store our fetch request, so that it can be looped over inside the body
    @FetchRequest var fetchRequest: FetchedResults<Singer>
    
    // Custom initializer that accepts a filter string and uses that to set the fetchRequest property. The _fetchRequest here is saying that we don't want to assign a list of results to our fetchRequest property, instead we want to write a wholly new fetch request.
    init(filter: String) {
        _fetchRequest = FetchRequest<Singer>(sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", filter))
    }
    
    var body: some View {
        List(fetchRequest, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
}
*/

// Generic filtered list that can be used with any entity and any property
struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    
    enum predicateOptions {
        case beginsWith, contains, predIn
    }

    // This is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    var body: some View {
        List(fetchRequest, id: \.self) { singer in
            self.content(singer)
        }
    }

    init(filterKey: String, filterValue: String, predicate: predicateOptions, sortDescriptors: [SortDescriptor<T>], @ViewBuilder content: @escaping (T) -> Content) {
        
        var stringPredicate: String

        switch predicate {
        case .beginsWith:
            stringPredicate = "BEGINSWITH"
        case .contains:
            stringPredicate = "CONTAINS"
        case .predIn:
            stringPredicate = "IN"
        }
        
        // %K is a special symbol that will insert our key values, but without quotes around them
        _fetchRequest = FetchRequest<T>(sortDescriptors: sortDescriptors, predicate: NSPredicate(format: "%K \(stringPredicate) %@", filterKey, filterValue))
        self.content = content
    }
}
