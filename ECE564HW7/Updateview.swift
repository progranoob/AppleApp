//
//  Updateview.swift
//  ECE564HW5
//
//  Created by Loaner on 2/25/23.
//

import SwiftUI

struct Updateview: View {
    @EnvironmentObject var database: ModelData
    var pers: DukePerson
    
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
    
    let genderoption: [String] = ["Unknown", "Male", "Female", "Other"]
    let roleoption: [String] = ["Professor", "TA", "Student", "Other"]
    
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    TextField("FirstName", text: $fName)
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.gray)
                        .cornerRadius(10)
                    TextField("LastName", text: $lName)
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.gray)
                        .cornerRadius(10)
                    TextField("From", text: $from)
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.gray)
                        .cornerRadius(10)
                    TextField("NetID", text: $netID)
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                //                        Spacer()
                //                            .shadow(color: .green, radius: 2)
                VStack{
                    TextField("hobby", text: $hobby)
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.gray)
                        .cornerRadius(10)
                    TextField("movie", text: $movie)
                        .padding()
                        .frame(width: 150, height: 40)
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
                                .frame(width: 150, height: 40)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .frame(width: 150, height: 40)
                    .background(Color.gray)
                    .cornerRadius(10)
                    
                    Picker("Role", selection: $role){
                        ForEach(roleoption, id:\.self){
                            Text($0)
                                .padding()
                                .frame(width: 150, height: 40)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .frame(width: 150, height: 40)
                    .background(Color.gray)
                    .cornerRadius(10)
                }
            }
            TextField("languages", text: $languages)
                .padding()
                .frame(width: 310, height: 40)
                .background(Color.gray)
                .cornerRadius(10)
            TextField("team", text: $team)
                .padding()
                .frame(width: 310, height: 40)
                .background(Color.gray)
                .cornerRadius(10)
            Spacer()
            if pers.picture == "" {
                Image("unloaded")
                    .resizable()
                    .cornerRadius(15)
                    .scaledToFit()
                    .shadow(radius: 5)
            }
            else{
                let newImageData = Data(base64Encoded: pers.picture)
                if let newImageData = newImageData {
                    Image(uiImage: UIImage(data: newImageData)!)
                        .resizable()
                        .frame(height: 200)
                        .frame(maxWidth: 200)
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
            Spacer()
            HStack{
                Button{
                    if !check(database: database.arr, netid: netID){
                        if pers.netid != netID{
                            textinfo = "Hey! Please don't modify the netid"
                            return
                        }
                        
                        for item in 0...database.arr.count-1{
                            if database.arr[item].netid == pers.netid{
                                database.arr[item].firstname = fName
                                database.arr[item].lastname = lName
                                database.arr[item].wherefrom = from
                                database.arr[item].movie = movie
                                database.arr[item].role = role
                                database.arr[item].team = team
                           
                                database.display[item].firstname = fName
                                database.display[item].lastname = lName
                                database.display[item].wherefrom = from
                                database.display[item].movie = movie
                                database.display[item].role = role
                                database.display[item].team = team
                                for i in 0...genderoption.count-1{
                                    if gender == genderoption[i]{
                                        database.arr[item].gender = i
                                        database.display[item].gender = i
                                    }
                                }
                                database.arr[item].languages = [""]
                                database.arr[item].languages.append(languages)
                                database.display[item].languages = [""]
                                database.display[item].languages.append(languages)
                                if netID == "xx92"{
                                    database.upload(dukemyself: database.arr[item])
                                }
                            }
                        }
                        
                        database.listupdate()
                        textinfo = "Success! This person has been updated to your database."
                        
                        
                    }
                    else{
                        textinfo = "Hey! Please don't modify the netid"
                    }
                } label: {
                    Text("Update")
                        .font(.headline)
                        .frame(width: 100, height: 50)
                }
                .buttonStyle(GrowingButton())
//                .padding(.trailing)
                
                Button{
//                    update()
                    fName = ""
                    netID = pers.netid
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

struct Updateview_Previews: PreviewProvider {
    static var previews: some View {
        Updateview(pers: ModelData().arr[0])
    }
}

func template(){
    
}
