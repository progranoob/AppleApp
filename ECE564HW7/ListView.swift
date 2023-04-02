//
//  ListView.swift
//  ECE564HW6
//
//  Created by Loaner on 2/28/23.
//

import SwiftUI

struct ListView: View {
    @StateObject var loaddata: ModelData
//    @StateObject var loaddata = ModelData()
    @State private var searchtext = ""
    @State var addbutton = false
    @State var updatebutton = false
    @State private var addMode = false
    @State private var alertMode = false
    @State private var popup = false
    @State private var propopup = false
    @State private var progress: Double = 0
    @State private var total: Double = 1
    @State private var observation: NSKeyValueObservation?
    
    var idToDelete: String = ""
    let genderoption: [String] = ["Unknown", "Male", "Female", "Other"]
    let roleoption: [String] = ["Professor", "TA", "Student", "Other"]
    
    
    var newperson = DukePerson(netid: "xx95", firstname: "Xichu", lastname: "Xiao", wherefrom: "CN", hobby: "badminton", movie: "The Great Gatsby", gender: 1, languages: ["Python", "C++"], role: "TA", picture: "", team: "", email:"xx92@duke.edu")
    
    var body: some View {
        NavigationStack{
            VStack{
                List {
                    Section(header: Text("🎓 Professor")){
                        ForEach(loaddata.professor, id:\.netid) { person in
                            NavigationLink{Readonly(pers:person)} label:{
                                HStack{
                                    if person.picture == "" {
                                        Image("unloaded")
                                            .resizable()
                                            .cornerRadius(15)
                                            .scaledToFit()
                                            .shadow(radius: 5)
                                    }
                                    else{
                                        let newImageData = Data(base64Encoded: person.picture)
                                        if let newImageData = newImageData {
                                            Image(uiImage: UIImage(data: newImageData)!)
                                                .resizable()
                                                .frame(maxWidth: 140, maxHeight: 150)
                                                .cornerRadius(15)
                                                .shadow(radius: 5)
                                        }
                                        else{
                                            Image("unloaded")
                                                .resizable()
                                                .cornerRadius(15)
                                                .scaledToFit()
                                                .shadow(radius: 5)
                                        }
                                    }
                                    VStack(alignment: .leading) {
                                        Text("\(person.firstname) \(person.lastname), \(person.netid)")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .foregroundColor(.black)
                                            .bold()
                                            .font(.custom("Arial", size: 16))
                                        Text("\n\(person.description)")
                                            .bold()
                                            .font(.custom("Arial", size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                }
                            }
                            .swipeActions{
                                NavigationLink(destination: Readonly(pers:person), label:{
                                    Button()
                                    {
                                        addbutton.toggle()
                                        
                                    } label: {
                                        Label("View", systemImage: "eye.circle.fill")
                                        
                                    }
                                })
                                .tint(.green)
                                
                                NavigationLink(destination: Updateview(pers:person, fName: person.firstname, netID: person.netid, lName: person.lastname, from: person.wherefrom, hobby: person.hobby, movie: person.movie, gender: genderoption[ person.gender], languages: dewrap(inner: person.languages) ,role: person.role, team: person.team), label:{
                                    Button()
                                    {
                                        addbutton.toggle()
                                        
                                    } label: {
                                        Label("Update", systemImage: "pencil.circle.fill")
                                    }
                                    
                                })
                                .tint(.yellow)
                            }
                            .swipeActions{
                                Button(){
                                    assign(loaddata: loaddata, person: person)
                                } label: {
                                    Label("Get", systemImage: "flag.circle.fill")
                                }
                                
                            }
                            .tint(.orange)
                            
                            .swipeActions{
                                Button(){
                                    print("BBB")
                                    loaddata.deletePeople(person: person)
                                    loaddata.listupdate()
                                } label: {
                                    Label("Delete", systemImage: "trash.circle.fill")
                                }
                                
                            }
                            .tint(.red)
                        }
                    }
                    
                    .font(.title)
                    .bold()
                    .foregroundColor(.cyan)
                    
                    Section(header: Text("😎 TA")){
                        ForEach(loaddata.TA, id:\.netid) { person in
                            NavigationLink{Readonly(pers:person)} label:{
                                HStack{
                                    if person.picture == "" {
                                        Image("unloaded")
                                            .resizable()
                                            .cornerRadius(15)
                                            .scaledToFit()
                                            .shadow(radius: 5)
                                    }
                                    else{
                                        let newImageData = Data(base64Encoded: person.picture)
                                        if let newImageData = newImageData {
                                            Image(uiImage: UIImage(data: newImageData)!)
                                                .resizable()
                                                .frame(maxWidth: 140, maxHeight: 150)
                                                .cornerRadius(15)
                                                .shadow(radius: 5)
                                        }
                                        else{
                                            Image("unloaded")
                                                .resizable()
                                                .cornerRadius(15)
                                                .scaledToFit()
                                                .shadow(radius: 5)
                                        }
                                    }
                                    VStack(alignment: .leading) {
                                        Text("\(person.firstname) \(person.lastname), \(person.netid)")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .foregroundColor(.black)
                                            .bold()
                                            .font(.custom("Arial", size: 16))
                                        
                                        Text("\n\(person.description)")
                                            .bold()
                                        
                                            .font(.custom("Arial", size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                }
                            }
                            .swipeActions{
                                NavigationLink(destination: Readonly(pers:person), label:{
                                    Button(){
                                        addbutton.toggle()
                                    } label: {
                                        Label("View", systemImage: "eye.circle.fill")
                                    }
                                })
                                .tint(.green)
                                
                                NavigationLink(destination: Updateview(pers:person, fName: person.firstname, netID: person.netid, lName: person.lastname, from: person.wherefrom, hobby: person.hobby, movie: person.movie, gender: genderoption[ person.gender], languages: dewrap(inner: person.languages) ,role: person.role, team: person.team), label:{
                                    Button(){
                                        addbutton.toggle()
                                    } label: {
                                        Label("Update", systemImage: "pencil.circle.fill")
                                    }
                                })
                                .tint(.yellow)
                            }
                            .swipeActions{
                                Button(){
                                    assign(loaddata: loaddata, person: person)
                                } label: {
                                    Label("Get", systemImage: "flag.circle.fill")
                                }
                            }
                            .tint(.orange)
                            
                            .swipeActions{
                                Button(){
                                    print("BBB")
                                    loaddata.deletePeople(person: person)
                                    loaddata.listupdate()
                                } label: {
                                    Label("Delete", systemImage: "trash.circle.fill")
                                }
                            }
                            .tint(.red)
                        }
                    }
                    .font(.title)
                    .bold()
                    .foregroundColor(.cyan)
             
                    Section(header: Text("🧐 Student")){
                        ForEach(loaddata.teammates, id:\.self){ name in
                            
                            if name != ""{
                                Text("Team: \(name)")
                                    .bold()
                                    .foregroundColor(Color.orange)
                                    .frame(maxHeight: 10)
                            }
                            else{
                                Text("N/A")
                                    .bold()
                                    .foregroundColor(Color.orange)
                                    .frame(maxHeight: 10)
                            }
                            let mates = loaddata.student.filter{
                                $0.team == name
                            }
                            ForEach(mates, id:\.netid) { person in
                                NavigationLink{Readonly(pers:person)} label:{
                                    HStack{
                                        if person.picture == "" {
                                            Image("unloaded")
                                                .resizable()
                                                .cornerRadius(15)
                                                .scaledToFit()
                                                .shadow(radius: 5)
                                        }
                                        else{
                                            let newImageData = Data(base64Encoded: person.picture)
                                            if let newImageData = newImageData {
                                                Image(uiImage: UIImage(data: newImageData)!)
                                                    .resizable()
                                                    .frame(maxWidth: 140, maxHeight: 150)
                                                    .cornerRadius(15)
                                                    .shadow(radius: 5)
                                            }
                                            else{
                                                Image("unloaded")
                                                    .resizable()
                                                    .cornerRadius(15)
                                                    .scaledToFit()
                                                    .shadow(radius: 5)
                                            }
                                        }
                                        VStack(alignment: .leading) {
                                            Text("\(person.firstname) \(person.lastname), \(person.netid)")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .foregroundColor(.black)
                                                .bold()
                                                .font(.custom("Arial", size: 16))
                                            
                                            Text("\n\(person.description)")
                                                .bold()
                                            
                                                .font(.custom("Arial", size: 12))
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                    }
                                }
                                .swipeActions{
                                    NavigationLink(destination: Readonly(pers:person), label:{
                                        Button(){
                                            addbutton.toggle()
                                        } label: {
                                            Label("View", systemImage: "eye.circle.fill")
                                        }
                                    })
                                    .tint(.green)
                                    
                                    NavigationLink(destination: Updateview(pers:person, fName: person.firstname, netID: person.netid, lName: person.lastname, from: person.wherefrom, hobby: person.hobby, movie: person.movie, gender: genderoption[ person.gender], languages: dewrap(inner: person.languages) ,role: person.role, team: person.team), label:{
                                        Button(){
                                            addbutton.toggle()
                                        } label: {
                                            Label("Update", systemImage: "pencil.circle.fill")
                                        }
                                    })
                                    .tint(.yellow)
                                }
                                .swipeActions{
                                    Button(){
                                        assign(loaddata: loaddata, person: person)
                                    } label: {
                                        Label("Get", systemImage: "flag.circle.fill")
                                    }
                                }
                                .tint(.orange)
                                
                                .swipeActions{
                                    Button(role: .destructive){
                                        print("BBB")
                                        alertMode = false
                                        loaddata.deletePeople(person: person)
                                        loaddata.listupdate()
                                    } label: {
                                        Label("Delete", systemImage: "trash.circle.fill")
                                    }
                                }
                            }
                        }
                    }
                    .font(.title)
                    .bold()
                    .foregroundColor(.cyan)
                    
                    Section(header: Text("🎓 Other")){
                        ForEach(loaddata.Other, id:\.netid) { person in
                            NavigationLink{Readonly(pers:person)} label:{
                                HStack{
                                    if person.picture == "" {
                                        Image("unloaded")
                                            .resizable()
                                            .cornerRadius(15)
                                            .scaledToFit()
                                            .shadow(radius: 5)
                                    }
                                    else{
                                        let newImageData = Data(base64Encoded: person.picture)
                                        if let newImageData = newImageData {
                                            Image(uiImage: UIImage(data: newImageData)!)
                                                .resizable()
                                                .frame(maxWidth: 140, maxHeight: 150)
                                                .cornerRadius(15)
                                                .shadow(radius: 5)
                                        }
                                        else{
                                            Image("unloaded")
                                                .resizable()
                                                .cornerRadius(15)
                                                .scaledToFit()
                                                .shadow(radius: 5)
                                        }
                                    }
                                    VStack(alignment: .leading) {
                                        Text("\(person.firstname) \(person.lastname), \(person.netid)")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .foregroundColor(.black)
                                            .bold()
                                            .font(.custom("Arial", size: 16))
                                        Text("\n\(person.description)")
                                            .bold()
                                            .font(.custom("Arial", size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                }
                                }
                                .swipeActions{
                                    NavigationLink(destination: Readonly(pers:person), label:{
                                        Button()
                                        {
                                            addbutton.toggle()
                                            
                                        } label: {
                                            Label("View", systemImage: "eye.circle.fill")
                                            
                                        }
                                    })
                                    .tint(.green)
                                    
                                    NavigationLink(destination: Updateview(pers:person, fName: person.firstname, netID: person.netid, lName: person.lastname, from: person.wherefrom, hobby: person.hobby, movie: person.movie, gender: genderoption[ person.gender], languages: dewrap(inner: person.languages) ,role: person.role, team: person.team), label:{
                                        Button(){
                                            addbutton.toggle()
                                        } label: {
                                            Label("Update", systemImage: "pencil.circle.fill")
                                        }
                                    })
                                    .tint(.yellow)
                                }
                                .swipeActions{
                                    Button(){
                                        assign(loaddata: loaddata, person: person)
                                    } label: {
                                        Label("Get", systemImage: "flag.circle.fill")
                                    }
                                }
                                .tint(.orange)
                                
                                .swipeActions{
                                    Button(role: .destructive){
                                        print("BBB")
                                        alertMode = false
                                        loaddata.deletePeople(person: person)
                                        loaddata.listupdate()
                                    } label: {
                                        Label("Delete", systemImage: "trash.circle.fill")
                                    }
                                }
                            }
                        }
                    
                    .font(.title)
                    .bold()
                    .foregroundColor(.cyan)
                }
                
                .searchable(text:$searchtext)
                .listStyle(.sidebar)
            }
            .navigationTitle("ECE564")
            .onAppear(){
//                loaddata.initData()
            }
            .navigationBarTitle(Text("Configure List Items"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                // button activates link
                self.addMode = true
            } ) {
                Image(systemName: "plus")
                    .resizable()
                    .padding(6)
                    .frame(width: 24, height: 24)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            } )
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button() {
                        popup = true
//                        loaddata.fetch()
                        print("Refresh tapped!")
                        
                    }label:{
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                    }
                    .actionSheet(isPresented: $popup) {
                        ActionSheet(
                            title: Text("select your refresh method"),
                            buttons: [
                                .default(Text("Replace")) {
                                    loaddata.fetch()
                                    propopup = true
                                },
                                
                                .default(Text("Update")) {
                                    for eachperson in loaddata.arr{
                                        assign(loaddata: loaddata, person: eachperson)
                                    }
                                },
                                
                                .default(Text("Load from disk")) {
                                    loaddata.preload()
                                },
                            ]
                        )
                    }
                    
                }
            }
            
            .onChange(of: searchtext) { newValue in
                loaddata.searchPeople(newValue: newValue)
            }
            .navigationDestination(isPresented: $addMode) {
                Information()
           }
            

        }
        .environmentObject(loaddata)
// upper for navigation stack, end here
    }
    
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(loaddata: ModelData())
    }
}

func printer( Local: [DukePerson]){
    for item in Local{
        print(item)
    }
}

func proffind(database: [DukePerson]) -> [DukePerson]{
    var prof = [DukePerson]()
    for item in database{
        if (item.role == "Professor"){
            prof.append(item)
        }
    }
    return prof
}

func studfind(database: [DukePerson]) -> [DukePerson]{
    var prof = [DukePerson]()
    for item in database{
        if (item.role == "Student"){
            prof.append(item)
        }
    }
    return prof
}

func tafind(database: [DukePerson]) -> [DukePerson]{
    var prof = [DukePerson]()
    for item in database{
        if (item.role == "TA"){
            prof.append(item)
        }
    }
    return prof
}

func otherfind(database: [DukePerson]) -> [DukePerson]{
    var prof = [DukePerson]()
    for item in database{
        if (item.role == "Other"){
            prof.append(item)
        }
    }
    return prof
}

func assign(loaddata: ModelData, person: DukePerson){
    for tem in loaddata.stored{
        if tem.netid == person.netid{
//            print(tem)
            for item in 0...loaddata.arr.count-1{
                if loaddata.arr[item].netid == tem.netid{

                    loaddata.arr[item].firstname = tem.firstname
                    loaddata.arr[item].lastname = tem.lastname
                    loaddata.arr[item].wherefrom = tem.wherefrom
                    loaddata.arr[item].movie = tem.movie
                    loaddata.arr[item].role = tem.role
                    loaddata.arr[item].team = tem.team
                    loaddata.arr[item].gender = tem.gender
                    loaddata.arr[item].languages = tem.languages
                    loaddata.arr[item].picture = tem.picture

                    loaddata.display[item].firstname = tem.firstname
                    loaddata.display[item].lastname = tem.lastname
                    loaddata.display[item].wherefrom = tem.wherefrom
                    loaddata.display[item].movie = tem.movie
                    loaddata.display[item].role = tem.role
                    loaddata.display[item].team = tem.team
                    loaddata.display[item].gender = tem.gender
                    loaddata.display[item].languages = tem.languages
                    loaddata.display[item].picture = tem.picture
                    loaddata.listupdate()
                }
            }
        }
    }
}
