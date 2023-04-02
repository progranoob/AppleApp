//
//  DukePerson.swift
//  test
//
//  Created by Loaner on 1/29/23.
//

import Foundation

//struct DukePerson: Codable {
//    var netid: String
//    var firstname: String
//    var lastname: String
//    var from: String
//    var hobby: String
//    var movie: String
//    // gender 0 = Unknown, 1 = Male, 2 = Female, 3 = Other
//    var gender: Int
//    var languages: [String]
//    var role: DukeRole
//}


struct DukePerson: Codable, Hashable{
//class DukePerson: Codable, ObservableObject{
    var netid: String
    var firstname: String
    var lastname: String
    var wherefrom: String
    var hobby: String
    var movie: String
    // gender 0 = Unknown, 1 = Male, 2 = Female, 3 = Other
    var gender: Int
    var languages: [String]
    var role: String
    var picture: String
    var team: String
    var email: String
    
//    = netid + "@duke.edu"
//    var email: String{
//        return netid + "@duke.edu"
//    }
}

enum DukeRole : String, Codable {
 case Professor = "Professor"
 case TA = "TA"
 case Student = "Student"
 case Other = "Other"
}

struct interface {
    var database = [DukePerson]()
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    let ArchiveURL = DocumentsDirectory.appendingPathComponent("ToDoJSONFile")
    
    mutating func addPerson(_ newPerson: DukePerson) -> Bool {
        if length_check(array: database){
            for counter in 0...database.count-1{
                if database[counter].netid == newPerson.netid{
                    print("This netid has already been registered!")
                }
                return false
            }
        }
        database.append(newPerson)
        return true
    }
    
    mutating func updatePerson(_ updatedPerson: DukePerson) -> Bool {
        if length_check(array: database){
            for counter in 0...database.count-1{
                if database[counter].netid == updatedPerson.netid{
                    database[counter] = updatedPerson
//                    print("Update success!")
                    return true
                }
            }
        }
        return false
    }
    
    mutating func findPerson(_ netid: String) -> DukePerson? {
        if length_check(array: database){
            for counter in 0...database.count-1{
                if database[counter].netid == netid{
//                    print("Here is the person found in the database")
//                    print(database[counter])
                    return database[counter]
                }
            }
        }
        return nil
    }
    
    mutating func deletePerson(_ netid: String) -> Bool {
        if length_check(array: database){
            for counter in 0...database.count-1{
                if database[counter].netid == netid{
                    database.remove(at: counter)
                    return true
                }
            }
        }
        return false
    }
    
    mutating func findPeople(lastName lastname: String, firstName firstname: String = "*") -> [DukePerson]? {
        if length_check(array: database){
            var found = [DukePerson]()
            if firstname == ""{
                for Item in 0...database.count-1{
                    if database[Item].lastname == lastname{
                        found.append(database[Item])
                    }
                }
            }
            else{
                for Item in 0...database.count-1{
                    
                    if database[Item].lastname == lastname && database[Item].firstname == firstname{
                        found.append(database[Item])
                    }
                }
            }
            return found
        }
        return nil
    }
    
    func listPeople() -> [DukePerson] {
        return database
    }
    
    func saveJSON() -> Bool {
        var outputData = Data()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.database) {
            if let json = String(data: encoded, encoding: .utf8) {
                print(json)
                outputData = encoded
            }
            else { return false }
            
            do {
                    try outputData.write(to: ArchiveURL)
            } catch let error as NSError {
                print (error)
                return false
            }
            return true
        }
        else { return false }
    }
    
    mutating func loadJSON() -> [DukePerson]? {
        let decoder = JSONDecoder()
        var todoItems = [DukePerson]()
        let tempData: Data
        
        do {
            tempData = try Data(contentsOf: ArchiveURL)
        } catch let error as NSError {
            print(error)
            return nil
        }
        if let decoded = try? decoder.decode([DukePerson].self, from: tempData) {
//            print(decoded[0].netid)
            todoItems = decoded
            self.database = todoItems
        }
        return todoItems
    }
}

func length_check (array:[DukePerson]) -> Bool{
    if array.count != 0{
        return true
    }
    else{
        print("The database now is empty, please 'add' someone first")
        return false
    }
}


// use extension here to print out description
//let someone = dukeperson(netid: "120", firstname: "Big", lastname: "Strong", from: "NC",
//                         hobby: "1", movie: "2",gender: 0, languages: ["3"],
//                         role: DukeRole(rawValue: "TA")!)
extension DukePerson: CustomStringConvertible {
    var description: String {
        var line = ""
        
        if firstname == "" && lastname == ""{
            line += "Someone"
        }
        else if firstname != "" && lastname != ""{
            line += firstname + " " + lastname
        }
        else{
            line += firstname + lastname
        }
        
        if wherefrom != ""{
            line += " is from \(wherefrom)"
        }
        
        if role != "" {
            if wherefrom != ""{
                line += " and is a \(role)"
            }
            else {
                line += " is a \(role)"
                
            }
        }
        line += ". "
        var pron: String
        if gender == 1{
            pron = "His"
        }
        else if gender == 2{
            pron = "Her"
        }
        else{
            pron = "Its"
        }
        if languages != [""]{
            line += "\(pron) best programming languages are"
            for item in languages{
                line += " \(item)"
            }
            line += ". "
        }
        if hobby != ""{
            line += "\(pron) favoriate hobby is \(hobby). "
        }
        if movie != ""{
            line += "\(pron) favoriate movie is \(movie). "
        }
        if email != ""{
            line += "\(pron) email address is \(email)"
        }
//        if firstname != "" || lastname != ""{
//            line += " with"
//
//            if firstname != ""{
//                line += " first name \(firstname)"
//                if lastname != ""{
//                    line += " and last name \(lastname)"
//                }
//            }
//            else{
//                if lastname != ""{
//                    line += " last name \(lastname)"
//                }
//            }
//        }
//        if wherefrom != ""{
//            line += " from \(wherefrom)"
//        }
//        if hobby != ""{
//            line += " with the favorite hobby \(hobby)"
//        }
//        if movie != ""{
//            line += " with the favorite movie \(movie)"
//        }
//        if gender != 0 {
//            line += " with gender"
//            // gender 0 = Unknown, 1 = Male, 2 = Female, 3 = Other
//            if gender == 1{
//                line += " Male"
//            }
//            if gender == 2{
//                line += " Female"
//            }
//            if gender == 3{
//                line += " Other"
//            }
//        }
//        if languages != [""]{
//            line += " with programming language "
//            for item in languages{
//                line += "\(item)"
//            }
//        }
//        if role != DukeRole(rawValue: ""){
//            line += " with the role in Duke as a \(role)"
//        }
            
        return line
        
    }
}
