//
//  ContentView.swift
//  ECE564HW6
//
//  Created by Loaner on 2/28/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .list
    @StateObject var loaddata = ModelData()
    
    enum Tab {
        case filtered
        case list
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ListView(loaddata: loaddata)
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.list)
        
            Filterview(loaddata: loaddata, searchfound: loaddata.arr)
                .tabItem {
                    Label("Filtered", systemImage: "bookmark.circle")
                    
                }
                .tag(Tab.filtered)
        }
        .environmentObject(loaddata)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
