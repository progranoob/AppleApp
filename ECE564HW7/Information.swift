//
//  Information.swift
//  ECE564HW5
//
//  Created by Loaner on 2/20/23.
//

import SwiftUI

struct Information: View {
    @State var fName = ""
    @State var netID = ""
    @State var lName = ""
    @State var from = ""
    @State var hobby = ""
    @State var movie = ""
    @State var gender = "Unknown"
    @State var languages = ""
    @State var role = "Other"
    @State var picture = ""
    @State var team = ""
    @State var email = ""
    @State var textinfo = "This is the information view"
    @EnvironmentObject var database: ModelData
    let genderoption: [String] = ["Unknown", "Male", "Female", "Other"]
    let roleoption: [String] = ["Professor", "TA", "Student", "Other"]
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    TextField("FirstName", text: $fName)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                    TextField("LastName", text: $lName)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                    TextField("From", text: $from)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                    TextField("NetID", text: $netID)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                //                        Spacer()
                //                            .shadow(color: .green, radius: 2)
                VStack{
                    TextField("hobby", text: $hobby)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                    TextField("movie", text: $movie)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
//                    TextField("gender", text: $gender)
//                        .padding()
//                        .frame(width: 150, height: 50)
//                        .background(Color.gray)
//                        .cornerRadius(10)
                    Picker("Gender", selection: $gender){
                        ForEach(genderoption, id:\.self){
                            Text($0)
                                .padding()
                                .frame(width: 150, height: 50)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .frame(width: 150, height: 50)
                    .background(Color.gray)
                    .cornerRadius(10)
                    
                    Picker("Role", selection: $role){
                        ForEach(roleoption, id:\.self){
                            Text($0)
                                .padding()
                                .frame(width: 150, height: 50)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .frame(width: 150, height: 50)
                    .background(Color.gray)
                    .cornerRadius(10)
                }
            }
            TextField("languages", text: $languages)
                .padding()
                .frame(width: 310, height: 50)
                .background(Color.gray)
                .cornerRadius(10)
            TextField("team", text: $team)
                .padding()
                .frame(width: 310, height: 50)
                .background(Color.gray)
                .cornerRadius(10)
            Spacer()
            Image("unloaded")
                .resizable()
                .cornerRadius(15)
                .scaledToFit()
                .shadow(radius: 5)
                .frame(maxWidth: 200, maxHeight: 200)
                .padding()
//            Spacer()
            HStack{
                Button{
                    if check(database: database.arr, netid: netID){
                        let newperson = add(netid: netID, fname: fName, lname:lName, hobby: hobby, movie: movie, from: from, role: role, gender: gender,language: languages, team: team)
                        print(newperson.description)
                        
                        database.display.append(newperson)
                        database.arr.append(newperson)
                        database.listupdate()
                        textinfo = "Success! New person has been added to your database."
                    }
                    else{
                        textinfo = "The netid has been registered."
                    }
                } label: {
                    Text("Add")
                        .font(.headline)
                        .frame(width: 100, height: 50)
                }
                .buttonStyle(GrowingButton())
                .padding(.trailing)
                
                Button{
//                    update()
                    fName = ""
                    netID = ""
                    lName = ""
                    from = ""
                    hobby = ""
                    movie = ""
                    gender = "Unknown"
                    languages = ""
                    role = "Other"
                    
                    textinfo = "This is the information view"
                } label: {
                    Text("Clear")
                        .font(.headline)
                        .frame(width: 100, height: 50)
                }
                .padding(.trailing)
                .buttonStyle(GrowingButton())
            }
            ScrollView{
                Text("\(textinfo)")
            }
        }
        
    }
}

struct Information_Previews: PreviewProvider {
    static var previews: some View {
        Information()
    }
}

func dewrap(inner: [String]) -> String{
    var connect = ""
    for i in 0..<inner.count {
        connect += inner[i]
        if i != inner.count-1 && inner[i] != ""{
            connect += ", "
        }
    }
    return connect
}

func check(database: [DukePerson], netid: String)-> Bool{
    for item in database{
        if item.netid == netid{
            return false
        }
    }
    return true
}

func add(netid: String, fname: String, lname: String, hobby: String, movie: String, from: String, role: String,gender: String, language: String, team: String)-> DukePerson{
    var newperson = DukePerson(netid: "xx92", firstname: "Xichu", lastname: "Xiao", wherefrom: "CN", hobby: "badminton", movie: "The Great Gatsby", gender: 1, languages: ["Python", "C++"], role: "Student", picture: "", team: "", email:"xx92@duke.edu")
    
    newperson.netid = netid
    newperson.picture = ""
    newperson.languages = [""]
    newperson.languages.append(language)
    newperson.role = role
    if gender == "Unknown"{
        newperson.gender = 0
    }
    else if gender == "Male"{
        newperson.gender = 1
    }
    else if gender == "Female"{
        newperson.gender = 2
    }
    else if gender == "Other"{
        newperson.gender = 3
    }
    newperson.email = netid+"@duke.edu"
    newperson.movie = movie
    newperson.hobby = hobby
    newperson.wherefrom = from
    newperson.lastname = lname
    newperson.firstname = fname
    newperson.team = team
//    newperson.team = ""

    return newperson
}

func update(){
    
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .background(Color.cyan)
            .cornerRadius(10)
//            .frame(width: 250, height: 150)
            .frame(maxWidth: .infinity)
            .frame(height: 150)
//            .padding()
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
