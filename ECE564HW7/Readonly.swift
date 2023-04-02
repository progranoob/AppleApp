//
//  Readonly.swift
//  ECE564HW5
//
//  Created by Loaner on 2/23/23.
//

import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct Readonly: View {

    @State private var flip: Bool = false
    @EnvironmentObject var database: ModelData
    var pers: DukePerson
    
    
    var body: some View {
        
        let lang = unwrap(inner: pers)
        VStack{
            if !flip{
                HStack{
                    
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
                                .frame(maxWidth: 300, maxHeight: 300)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                        else{
                            Image("unloaded")
                                .resizable()
                                .frame(maxWidth: 300, maxHeight: 300)
                                .cornerRadius(15)
                                .scaledToFit()
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(alignment: .center)
                .padding()
                HStack{
                    Text("\( pers.firstname) \(pers.lastname), ")
                    Text("\(pers.netid)")
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(.black)
                .bold()
                .font(.custom("Arial", size: 20))
                //            .background(Color(.white))
                
                List{
                    Text("🏠From : \(pers.wherefrom)")
                    Text("🎓Role: \(pers.role)")
                    Text("✉️Email: \(pers.email)")
                    
                    if pers.gender == 0{
                        Text("👤Gender: Unknown")
                    }
                    else if pers.gender == 1{
                        Text("👤Gender: Male")
                    }
                    else if pers.gender == 2{
                        Text("👤Gender: Female")
                    }
                    else{
                        Text("Gender: Other")
                    }
                    
                    Text("🥇Favoriate Hobby: \(pers.hobby)")
                    Text("🎬Favoriate Movie: \(pers.movie)")
                    HStack{
                        Text("⌨️Coding Language: \(lang)")
                        
                    }
                    
                    
                    //                Text("\(pers.languages)")
                    
                    
                }
            }
            else{
                AnimationView()
                    .rotation3DEffect(Angle(degrees: 180), axis: (x:0.0, y:1.0,z:0.0))
                    
            }
            
        }
        .background(Color(.lightGray))
        .rotation3DEffect(flip ? Angle(degrees: 180): .zero , axis: (x:0.0, y:1.0,z:0.0)
        )
        .animation(.default, value: flip)
        .onTapGesture {
            flip.toggle()
            player?.stop()
        }

    }

    
}

struct Readonly_Previews: PreviewProvider {
    static var previews: some View {
        Readonly(pers: ModelData().arr[1])
    }
}

func unwrap(inner: DukePerson) -> String{
    var connect = ""
    for i in 0..<inner.languages.count {
        connect += inner.languages[i]
        if i != inner.languages.count-1{
            connect += ", "
        }
    }
    return connect
}




