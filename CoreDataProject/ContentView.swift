//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Steven Gustason on 4/26/23.
//

import SwiftUI

// Hashable s a protocol that means Swift can generate hash values for it, which in turn means we can use \.self for the identifier. Similar to codable, if all of an object's properties conform to Hashable, the object itself conforms automatically. For Core Data specifically, the objects it creates for us actually have a selection of other properties beyond those we defined in our data model, including one called the object ID – an identifier that is unique to that object, regardless of what properties it contains, so we can have two of the same object and they'll still be uniquely identifiable with \.self
struct Student: Hashable {
    let name: String
}

struct ContentView: View {
    // Add our managed object context
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>
    
    let students = [Student(name: "Harry Potter"), Student(name: "Hermione Granger")]
    
    func save() {
        // Whenever we want to save our changes, we should always check whether any changes have been made - like so. This will lower the performance impact of our app since we won't be saving unnecessarily. Note: This doesn't need to be in a function, the function is just for demonstration of the below check.
        if moc.hasChanges {
            try? moc.save()
        }
    }
    
    var body: some View {
        // This allows us to use \.self in lists, ForEachs, etc.
        List(students, id: \.self) { student in
            Text(student.name)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
