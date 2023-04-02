//
//  SearchViewController.swift
//  test
//
//  Created by Xichu on 1/29/23.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController{
    
    @IBOutlet weak var ScrollText: UITextView!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var netid: UITextField!
    @IBOutlet weak var from: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var progL: UITextField!
    @IBOutlet weak var hobby: UITextField!
    @IBOutlet weak var movie: UITextField!
    @IBOutlet weak var team: UITextField!
    
    @IBOutlet weak var listbutton: UIButton!
    @IBOutlet weak var searchbutton: UIButton!
//    @IBOutlet weak var returnbutton: UIButton!
    @IBOutlet weak var returnbutton: UIButton!
    
    @IBOutlet weak var clearbutton: UIButton!
    
    
    @Binding var searchfound : [DukePerson]
    @Binding var saver : [savedperson]
//    var searchfound : ModelData

    var loaded : ModelData
    var counter = 0
    
    var httpString = "https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg"
    var infotype = ""
    var tt = "https://ece564sp23.colab.duke.edu/entries"
    let usrname = "xx92"
    let password = "dde9e94325b135e016658c82ccff79c0c806cfe8ad990752e649b78d6056bd4d"
    var stored = interface()
    
    init(searchfound: Binding<[DukePerson]>, loaddata: ModelData, saver: Binding<[savedperson]>){
        self._searchfound = searchfound
        self._saver = saver
        self.loaded = loaddata
//        self.searchfound = searchfound
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func Listpressed(_ sender: Any) {
        print("list")
        if searchfound.count == 0{
            ScrollText.text = "Opps! Nobody is found."
            return
        }
        
        var allpeople = ""
//        allpeople += "\(searchfound.count)" + " people are in the database! \n"
        var counter = 0
        for pers in searchfound{
            counter += 1
            allpeople += "\(counter). " + pers.firstname + " " + pers.lastname + ", " + pers.netid + "\n"
        }
        ScrollText.text = allpeople
    }
    
    @IBAction func Searchpressed(_ sender: Any) {
        print("search")

        if let gender = Int(gender.text!){
            if gender != 0 && gender != 1 && gender != 2 && gender != 3{
                ScrollText.text = "Please specify a legel gender with a number! \nHint: 0 for unknown, 1 for Male, 2 for Female, 3 for Other"
                return
            }
        }
        else if gender.text == ""{
//            ScrollText.text
        }
        else{
            ScrollText.text = "Unexpected input of gender, please specify a number from 0 to 3. \nHint: 0 for unknown, 1 for Male, 2 for Female, 3 for Other"
            return
        }
        if role.text == ""{
        }
        else{
            let roles = role.text?.uppercased()
            if roles != "TA" && roles != "STUDENT" && roles != "PROFESSOR" && roles != "OTHER"{
                ScrollText.text = "Please specify a legel role with a professor or TA or student or Other, case is insensitive."
                return
            }
        }
        var found = [DukePerson]()
        
        for pers in loaded.arr{
            if firstname.text != ""{
                let pfirstname = pers.firstname.lowercased()
                let firstnametext = firstname.text!.lowercased()
                if !pfirstname.contains(firstnametext){
                    continue
                }
            }
            if lastname.text != ""{
                let plastname = pers.lastname.lowercased()
                let lastnametext = lastname.text!.lowercased()
                if !plastname.contains(lastnametext){
                    continue
                }
            }
            if netid.text != ""{
                if pers.netid != netid.text{
                    continue
                }
            }
            if from.text != ""{
                let pwherefrom = pers.wherefrom.lowercased()
                let fromtext = from.text!.lowercased()
                if !pwherefrom.contains(fromtext){
                    continue
                }
            }
            if gender.text != ""{
                if Int(gender.text!) != pers.gender{
                    continue
                }
            }
            if role.text != ""{
                let prole = pers.role.lowercased()
                let roletext = role.text!.lowercased()
                if roletext != prole{
                    continue
                }
            }
            if movie.text != ""{
                let pmovie = pers.movie.lowercased()
                let movietext = movie.text!.lowercased()
                if !pmovie.contains(movietext){
                    continue
                }
            }
            if hobby.text != ""{
                let phobby = pers.hobby.lowercased()
                let hobbytext = hobby.text!.lowercased()
                if !phobby.contains(hobbytext){
                    continue
                }
            }
            if team.text != ""{
                let pteam = pers.team.lowercased()
                let teamtext = team.text!.lowercased()
                if !pteam.contains(teamtext){
                    continue
                }
            }
            if progL.text != ""{
                var flag = 0
                let sub = progL.text?.components(separatedBy: ",")
                for item in sub!{
                    if !pers.languages.contains(item){
                        flag = 1
                    }
                }
                if flag == 1{
                    continue
                }
            }
            found.append(pers)
        }
        searchfound = found
        let str = "\(found.count) people are found in the database! \n"

        ScrollText.text = str + "Press list button to see people found."
        
    }
    
    
    @IBAction func Returnpressed(_ sender: Any) {
        print("return")
        dismiss(animated: true)
    }
    
    @IBAction func Clearpressed(_ sender: Any) {
        firstname.text = ""
        lastname.text = ""
        netid.text = ""
        from.text = ""
        gender.text = ""
        role.text = ""
        progL.text = ""
        hobby.text = ""
        movie.text = ""
        team.text = ""
        ScrollText.text = "This is the output window: "
    }
    
    @IBAction func Savepressed(_ sender: Any) {
        counter += 1
        var newperson = savedperson()
        newperson.person = searchfound
        newperson.index = counter
        var info = ""
        if firstname.text != ""{
            info += "firstname:" + firstname.text! + " "
        }
        if lastname.text != ""{
            info += "lastname:" + lastname.text! + " "
        }
        if netid.text != ""{
            info += "netid:" + netid.text! + " "
        }
        if from.text != "" {
            info += "from:" + from.text! + " "
        }
        if gender.text != ""{
            info += "gender:" + gender.text! + " "
        }
        if role.text != ""{
            info += "role:" + role.text! + " "
        }
        if progL.text != ""{
            info += "progL:" + progL.text! + " "
        }
        if hobby.text != ""{
            info += "hobby:" + hobby.text! + " "
        }
        if movie.text != ""{
            info += "movie:" + movie.text! + " "
        }
        if team.text != ""{
            info += "team:" + team.text! + " "
        }
        newperson.des = "of " + info
        saver.append(newperson)
        ScrollText.text = "Current Search has been saved!"
    }
}


