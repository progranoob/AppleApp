//
//  Filterview.swift
//  ECE564HW6
//
//  Created by Loaner on 3/7/23.
//

import SwiftUI

struct Filterview: View {
    @State private var ispresent = false
    @StateObject var loaddata: ModelData
    @State var searchfound : [DukePerson]
//    var searchfound: ModelData
    @State private var popup = false
    @State private var savepopup = false
    @State var saver = [savedperson]()
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(searchfound, id: \.self){ person in
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
            }
            .navigationTitle("ECE564")
            .navigationBarItems(trailing: Button() {
                // button activates link
                popup = true
                //                        loaddata.fetch()
                print("Refresh tapped!")
            }
            label:{
                Image(systemName: "arrow.counterclockwise.circle.fill")
            }
            .actionSheet(isPresented: $popup) {
                ActionSheet(
                    title: Text("select your refresh method"),
                    buttons: [
                        .default(Text("Replace")) {
                            loaddata.fetch()
                            searchfound = loaddata.arr
                        },
                        
                        .default(Text("Update")) {
                            for eachperson in loaddata.arr{
                                assign(loaddata: loaddata, person: eachperson)
                            }
                            searchfound = loaddata.arr
                        },
                        
                        .default(Text("Load from disk")) {
                            loaddata.preload()
                            searchfound = loaddata.arr
                        },
                    ]
                )
                
            })
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button() {
                        savepopup = true
                        print("Save tapped!")
                        
                    }
                    label:{
                        Image(systemName: "square.and.arrow.down")
                    }
                    .actionSheet(isPresented: $savepopup, content: {
                        ActionSheet(title: Text("Saved History"), buttons:
                            saver.map { size in
                                .default(Text("Searched History \(size.des)")) {
                                    searchfound = size.person
                                    savepopup = false
                                }
                            }
                        )
                    })
                    
                }

            }
            
            
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button() {
                        ispresent = true
                        print("Refresh tapped!")
                        
                    }label:{
                        Image(systemName: "filemenu.and.selection")
                    }
                }
            }
            .sheet(isPresented: $ispresent){
                Representable(searchfound: $searchfound, saver: $saver, loaddata: loaddata)
            }
        }
//        .environmentObject(searchfound)
    }
    
}


struct savedperson{
    var person = [DukePerson]()
    var index = 0
    var des = ""
}
