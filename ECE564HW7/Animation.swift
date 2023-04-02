//
//  Animation.swift
//  ECE564HW7
//
//  Created by Loaner on 4/1/23.
//

import SwiftUI
import AVFoundation
import UIKit
var player: AVAudioPlayer!

struct AnimationView: View {
    @State private var fade = false
    @State private var fade2 = true
    
    var message: AttributedString {
        var result = AttributedString("Sleeping day and night~")
        result.font = .largeTitle
        result.foregroundColor = .indigo
        result.underlineStyle = Text.LineStyle(
            pattern: .solid, color: .purple)
        result.font = .largeTitle
        
//        result.backgroundColor = .red
        return result
    }
    
    var mess: AttributedString {
        let string = "Good Morning! Good Afternoon! Good Evening! And Good Night!"
        var result = AttributedString()
        
        for (index, letter) in string.enumerated() {
            var letterString = AttributedString(String(letter))
            letterString.baselineOffset = sin(Double(index)) * 5
            result += letterString
        }
        result.foregroundColor = .magenta
        result.font = UIFont(name: "Arial", size: 25)
        
        return result
    }
    func playSound(){
        let url = Bundle.main.url(forResource: "riddance", withExtension: "m4a")
        guard url != nil else{
            
            print("wrong")
            return
        }
        print("\(url!)")
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player?.play()
        }catch{
            print("error")
        }
    }
    
    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        ZStack{
            Image("sleeping")
                .resizable()
                .cornerRadius(15)
                .frame(maxHeight: .infinity )
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                .scaledToFit()
                .shadow(radius: 5)
                .opacity(0.3)
            VStack{
                Text(message)
                    .offset(y: 30)
                Button(action: {
                    print("pressed")
                    self.playSound()
                },label: {
                    Text("Music")
//                        .offset(y:-90)
                        .font(.headline)
                        .frame(width: 100, height: 50)
                }).buttonStyle(GrowingButton())
//                    .offset(y:10)
                
                GeometryReader { geometry in
                    Path { path in
                        let width = min(geometry.size.width, geometry.size.height)
                        let height = width * 0.75
                        let spacing = width * 0.030
                        let middle = width * 1.55
                        let topWidth = width * 0.226/2
//                        let toppHeight = height*1.6
                        let topHeight = height * -0.288
                        let tall = width*0.5/2/1.5
                        let short = width*0.10
                        
                        path.addLines([
                            CGPoint(x: middle - topWidth, y: topHeight - spacing),
                            CGPoint(x: middle + topWidth, y: topHeight - spacing),
                            CGPoint(x: middle + topWidth, y: topHeight),
                            CGPoint(x: middle - topWidth+short, y: topHeight + tall),
                            CGPoint(x: middle + topWidth, y: topHeight+tall),
                            CGPoint(x: middle + topWidth, y: topHeight+tall+spacing),
                            CGPoint(x: middle - topWidth, y: topHeight+tall+spacing),
                            CGPoint(x: middle - topWidth, y: topHeight+tall),
                            CGPoint(x: middle + topWidth-short, y: topHeight),
                            
                            CGPoint(x: middle - topWidth, y: topHeight),
                        ])
                    }
                    .fill(Color.indigo)
                    
                }.padding()
                    .onAppear(){
                        withAnimation(Animation.easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true))
                        {fade.toggle()}
                        
                    }.opacity(fade ? 0 : 1)
                
                
                GeometryReader { geometry in
                    Path { path in
                        let width = min(geometry.size.width, geometry.size.height)
                        let height = width * 0.75
                        let spacing = width * 0.030
                        let middle = width * 1.15
                        let topWidth = width * 0.226/2
                        let toppHeight = -height*1
//                        let topHeight = height * 0.488
                        let tall = width*0.5/2/1.5
                        let short = width*0.10
                        
                        path.addLines([
                            CGPoint(x: middle - topWidth, y: toppHeight - spacing),
                            CGPoint(x: middle + topWidth, y: toppHeight - spacing),
                            CGPoint(x: middle + topWidth, y: toppHeight),
                            CGPoint(x: middle - topWidth+short, y: toppHeight + tall),
                            CGPoint(x: middle + topWidth, y: toppHeight+tall),
                            CGPoint(x: middle + topWidth, y: toppHeight+tall+spacing),
                            CGPoint(x: middle - topWidth, y: toppHeight+tall+spacing),
                            CGPoint(x: middle - topWidth, y: toppHeight+tall),
                            CGPoint(x: middle + topWidth-short, y: toppHeight),
                            
                            CGPoint(x: middle - topWidth, y: toppHeight),
                        ])
                    }
                    .fill(Color.indigo)
                }
                .onAppear(){
                    withAnimation(Animation.easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true))
                    {fade2.toggle()}
                    
                }.opacity(fade2 ? 0 : 1)
                
                ClockView()
                    .offset(y:-200)
                
                Text(mess)
                    .offset(y: -170)
                    
                
            }
        }
    }
}

struct Animation_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
    }
}

struct ClockView: View{
    var width = UIScreen.screenWidth/1.5
    @State var cur = Time(min: 0, sec: 0, hr: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    var body: some View{
        VStack{
            ZStack{
                Circle()
                    .fill(Color.purple).opacity(0.1)
                ForEach(0..<60, id: \.self){ i in
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2,height: (i % 5) == 0 ? 15 : 5)
                        .offset(y: (width-110)/2)
                        .rotationEffect(.init(degrees: Double(i)*6))
                }
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 3.5, height: (width-160)/2)
                    .offset(y: -(width-180)/4)
                    .rotationEffect(.init(degrees: Double(cur.sec)*6))
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4, height: (width-180)/2)
                    .offset(y: -(width-200)/4)
                    .rotationEffect(.init(degrees: Double(cur.min)*6))
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 4.5, height: (width-200)/2)
                    .offset(y: -(width-240)/4)
                    .rotationEffect(.init(degrees: Double(cur.hr)*30))
                Circle()
                    .fill(Color.primary)
                    .frame(width: 15,height: 15)
            }
            .frame(width: width-80, height: width-40)
        }
        .onAppear(perform: {
            let date = Calendar.current
            let min = date.component(.minute, from: Date())
            let sec = date.component(.second, from: Date())
            let hr = date.component(.hour, from: Date())
            withAnimation(Animation.linear(duration:0.1)){
                self.cur = Time(min: min, sec: sec, hr: hr)
            }
        })
        .onReceive(receiver){ (_) in
            let date = Calendar.current
            let min = date.component(.minute, from: Date())
            let sec = date.component(.second, from: Date())
            let hr = date.component(.hour, from: Date())
            withAnimation(Animation.linear(duration:0.1)){
                self.cur = Time(min: min, sec: sec, hr: hr)
            }
        }
        
    }
}

struct Time{
    var min: Int
    var sec: Int
    var hr: Int
}

