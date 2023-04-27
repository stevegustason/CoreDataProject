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
    
    @FetchRequest(sortDescriptors: [], predicate: nil) var ships: FetchedResults<Ship>
    
    let students = [Student(name: "Harry Potter"), Student(name: "Hermione Granger")]
    
    func save() {
        // Whenever we want to save our changes, we should always check whether any changes have been made - like so. This will lower the performance impact of our app since we won't be saving unnecessarily. Note: This doesn't need to be in a function, the function is just for demonstration of the below check.
        if moc.hasChanges {
            try? moc.save()
        }
    }
    
    var body: some View {
        VStack {
            List(wizards, id: \.self) { wizard in
                Text(wizard.name ?? "Unknown")
            }
            
            Button("Add") {
                let wizard = Wizard(context: moc)
                wizard.name = "Harry Potter"
            }
            
            Button("Save") {
                do {
                    try moc.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            // This allows us to use \.self in lists, ForEachs, etc.
            List(students, id: \.self) { student in
                Text(student.name)
            }
            
            List(ships, id: \.self) { ship in
                            Text(ship.name ?? "Unknown name")
                        }

            Button("Add Examples") {
                let ship1 = Ship(context: moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"
                
                let ship2 = Ship(context: moc)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"
                
                let ship3 = Ship(context: moc)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"
                
                let ship4 = Ship(context: moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"
                
                try? moc.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
