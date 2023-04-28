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
    
    // NSPredicate allows us to filter our fetch requests. Here, we're only showing ships where the universe property equals Star Wars. %@ allows use to provide the data as a paramater rather than inline, which gets around weird parentheses issues.
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe == %@", "Star Wars")) var ships: FetchedResults<Ship>
    
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    
    /*
     As well as ==, we can also use comparisons such as < and > to filter our objects. For example this will return Defiant, Enterprise, and Executor:

     NSPredicate(format: "name < %@", "F"))

     %@ is doing a lot of work behind the scenes, particularly when it comes to converting native Swift types to their Core Data equivalents. For example, we could use an IN predicate to check whether the universe is one of three options from an array, like this:

     NSPredicate(format: "universe IN %@", ["Aliens", "Firefly", "Star Trek"])

     We can also use predicates to examine part of a string, using operators such as BEGINSWITH and CONTAINS. For example, this will return all ships that start with a capital E:

     NSPredicate(format: "name BEGINSWITH %@", "E"))

     That predicate is case-sensitive; if you want to ignore case you need to modify it to this:

     NSPredicate(format: "name BEGINSWITH[c] %@", "e"))

     CONTAINS[c] works similarly, except rather than starting with your substring it can be anywhere inside the attribute.

     Finally, you can flip predicates around using NOT, to get the inverse of their regular behavior. For example, this finds all ships that don’t start with an E:

     NSPredicate(format: "NOT name BEGINSWITH[c] %@", "e"))
     */
    
    let students = [Student(name: "Harry Potter"), Student(name: "Hermione Granger")]
    
    func save() {
        // Whenever we want to save our changes, we should always check whether any changes have been made - like so. This will lower the performance impact of our app since we won't be saving unnecessarily. Note: This doesn't need to be in a function, the function is just for demonstration of the below check.
        if moc.hasChanges {
            try? moc.save()
        }
    }
    
    @State private var lastNameFilter = "A"
    
    var body: some View {
        VStack {
            /*
            // Day 1 content
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
             */
            
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
            
            /*
            // Add our filtered list view, which passes in the filter to be used
            FilteredList(filter: lastNameFilter)
             */
            
            // Since our FilteredList view is generic now, we have to pass in the filterKey, value, and also the closure parameter so Swift understands how this view is being used
            FilteredList(filterKey: "lastName", filterValue: lastNameFilter, predicate: .beginsWith, sortDescriptors: [SortDescriptor(\.firstName, order: .reverse)]) { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }
            
            Button("Add Examples") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"
                
                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"
                
                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"
                
                try? moc.save()
            }

            // Sets our filter to "A"
            Button("Show A") {
                lastNameFilter = "A"
            }

            // Sets our filter to "S"
            Button("Show S") {
                lastNameFilter = "S"
            }
            
            // List with two ForEach views inside it: one to create a section for each country, and one to create the candy inside each country. All of our candies are automatically sorted into sections based on the work we did in our NSManagedObject subclasses and because they're linked entities.
            VStack {
                List {
                    ForEach(countries, id: \.self) { country in
                        Section(country.wrappedFullName) {
                            ForEach(country.candyArray, id: \.self) { candy in
                                Text(candy.wrappedName)
                            }
                        }
                    }
                }

                Button("Add") {
                    let candy1 = Candy(context: moc)
                    candy1.name = "Mars"
                    candy1.origin = Country(context: moc)
                    candy1.origin?.shortName = "UK"
                    candy1.origin?.fullName = "United Kingdom"

                    let candy2 = Candy(context: moc)
                    candy2.name = "KitKat"
                    candy2.origin = Country(context: moc)
                    candy2.origin?.shortName = "UK"
                    candy2.origin?.fullName = "United Kingdom"

                    let candy3 = Candy(context: moc)
                    candy3.name = "Twix"
                    candy3.origin = Country(context: moc)
                    candy3.origin?.shortName = "UK"
                    candy3.origin?.fullName = "United Kingdom"

                    let candy4 = Candy(context: moc)
                    candy4.name = "Toblerone"
                    candy4.origin = Country(context: moc)
                    candy4.origin?.shortName = "CH"
                    candy4.origin?.fullName = "Switzerland"

                    try? moc.save()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
