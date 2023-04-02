//
//  Modeldata.swift
//  ECE564HW4
//
//  Created by Loaner on 2/15/23.
//

import Foundation
import SwiftUI

final class ModelData: ObservableObject {
    
    let myself = DukePerson(netid: "xx92", firstname: "Xichu", lastname: "Xiao", wherefrom: "CN", hobby: "badminton", movie: "The Great Gatsby", gender: 1, languages: ["Python", "C++"], role: "Student", picture: "", team: "", email:"xx92@duke.edu")
    @Published var arr = [DukePerson]()
    @Published var display = [DukePerson]()
    @Published var professor = [DukePerson]()
    @Published var student = [DukePerson]()
    @Published var TA = [DukePerson]()
    @Published var Other = [DukePerson]()
    @Published var teammates: [String] = []
    @Published var stored = [DukePerson]()
    
//    @Published var person = [DukePerson]()
//    @Published var professor = proffind(database: display)
//    @Published var student = studfind(database: display)
//    @Published var TA = tafind(database: display)
//    @Published var Other = otherfind(database: display)
    func listupdate(){
        professor = proffind(database: display)
        student = studfind(database: display)
        TA = tafind(database: display)
        Other = otherfind(database: display)
        for item in student{
            var flag = 0
            for name in teammates{
                if name == item.team{
                    flag = 1
                }
            }
            if (flag == 0){
                teammates.append(item.team)
            }
        }
    }
    
    init(){
        prefetch()
        preload()
        display = arr
//        fetch()
    }
    
    func deletePeople(person: DukePerson){
        if display.count <= 0{
            return
        }

        for item in 0...display.count-1{
            if display[item].netid == person.netid{
                display.remove(at: item)
                arr.remove(at: item)
                break
            }
        }

        return
    }
    
    
    func searchPeople(newValue:String) {
        display = newValue == "" ? arr : arr.filter{
            $0.description.lowercased().contains(newValue.lowercased())
        }
        listupdate()
        
    }
    
    func prefetch(){
        let usrname = "xx92"
        let password = "dde9e94325b135e016658c82ccff79c0c806cfe8ad990752e649b78d6056bd4d"
//        let password = "random"
        let base = "https://ece564sp23.colab.duke.edu/entries/all"
        let testurl = URL(string: base)
        var request = URLRequest(url: testurl!)
        let dat = (usrname+":"+password).data(using: .utf8)!.base64EncodedString()
        request.httpMethod = "GET"
        request.setValue("Basic \(dat)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else{return}
//            if let response = response {
//                print(response.debugDescription)
//            }
            do{
                let info = try JSONDecoder().decode([DukePerson].self, from: data)
                DispatchQueue.main.async {
//                    print(info.count)
                    self.stored = info
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
        
//        observation = session?.progress.observe(\.fractionCompleted){ observationProgress, _ in
//            
//        }
        session.resume()
    }
    
    func fetch(){
        let usrname = "xx92"
        let password = "dde9e94325b135e016658c82ccff79c0c806cfe8ad990752e649b78d6056bd4d"
//        let password = "random"
        let base = "https://ece564sp23.colab.duke.edu/entries/all"
        let testurl = URL(string: base)
        var request = URLRequest(url: testurl!)
        let dat = (usrname+":"+password).data(using: .utf8)!.base64EncodedString()
        request.httpMethod = "GET"
        request.setValue("Basic \(dat)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else{return}
//            if let response = response {
//                print(response.debugDescription)
//            }
            do{
                let info = try JSONDecoder().decode([DukePerson].self, from: data)
                DispatchQueue.main.async {
//                    print(info.count)
                    self.arr = info
                    self.stored = info
                    self.display = self.arr
                    self.listupdate()
                }
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
        session.resume()
        
    }
    
    func preload(){
        var local = [DukePerson]()
        print("Loading json file now")
        if let localURL = Bundle.main.url(forResource:"ECE564Cohort", withExtension: "json") {
            print("JSON found!")
            let decoder = JSONDecoder()
            let data = try? Data(contentsOf: localURL)
            //                print(data)
//            print("safe")
            do {
                let jsondata = try decoder.decode([DukePerson].self, from: data!)
                print("Load done!")
                for json in jsondata{
                    //                        print(json)
                    local.append(json)
                }
                
            }
            catch { print("Couldn't load JSON file") }
        }
//        print(local)
        arr = local
        display = local
        listupdate()
    }
    
    func upload(dukemyself:DukePerson){
    
        let usrname = "xx92"
        let password = "dde9e94325b135e016658c82ccff79c0c806cfe8ad990752e649b78d6056bd4d"
        let dat = (usrname+":"+password).data(using: .utf8)!.base64EncodedString()
//        let pic2 = UIImage(named: "self.jpg")

//        let imageData = pic2?.jpegData(compressionQuality: 0.5)
//        guard let imageBase64String = imageData?.base64EncodedString() else { return }
//        let myself = DukePerson(netid: "xx92", firstname: "Xichu", lastname: "Xiao", wherefrom: "China", hobby: "badminton", movie: "The Great Gatsby", gender: 1, languages: ["Python", "C++"], role: "Student", picture: imageBase64String, team: "Gather Green", email:"xx92@duke.edu")
//
        let myself = dukemyself

        let ttt = "https://ece564sp23.colab.duke.edu/entries/xx92"
        let testurl = URL(string: ttt)
        guard let requestUrl = testurl else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.setValue("Basic \(dat)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(myself)
        request.httpBody = jsonData
        
        let taskss = URLSession.shared.uploadTask(with: request, from: jsonData, completionHandler:{
            data, response, error in
            if error != nil{
                print("reached!")
                print("\(String(describing: error))")
            }
            print("no error?")
            print(String(data: jsonData!, encoding: String.Encoding.utf8) as Any)
            print(response as Any)
        })
        taskss.resume()
    }

    
}

