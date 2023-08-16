//
//  ContentView.swift
//  ARSampleToFaceApp
//
//  Created by Oh!ara on 2023/08/14.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ARContainerViewController {
        return ARContainerViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARContainerViewController, context: Context) {
        
    }
}
#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
