//
//  Representable.swift
//  ECE564HW6
//
//  Created by Loaner on 3/7/23.
//

import SwiftUI

struct Representable: UIViewControllerRepresentable {
//    @EnvironmentObject var searchfound : ModelData
    @Binding var searchfound : [DukePerson]
    @Binding var saver : [savedperson]
    var loaddata: ModelData
    
    func makeUIViewController(context: Context) -> some UIViewController {
//        let vc = SearchViewController(searchfound: $searchfound)
        let vc = SearchViewController(searchfound: $searchfound, loaddata: loaddata, saver: $saver)

        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> ViewCoordinator {
        Coordinator(self)
    }

}

//struct Representable_Previews: PreviewProvider {
//    static var previews: some View {
//        Representable()
//    }
//}

final class ViewCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parent: Representable
    
    init(_ parent: Representable) {
        self.parent = parent
    }
}
