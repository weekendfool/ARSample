//
//  VirtureObject.swift
//  ARSampleToFaceApp
//
//  Created by Oh!ara on 2023/08/14.
//

import RealityKit
import ARKit
import Combine

class VirtureObject {
    
    var modelAnchor: AnchorEntity
    var modelEntity: ModelEntity?
    
    var cancellable: AnyCancellable?
    
    init(modelAnchor: AnchorEntity) {
        self.modelAnchor = modelAnchor
       
    }
    
    func loadModel(name: String, nameExtension: String, completion: @escaping(Bool)->Void) {
        
        guard let url = Bundle.main.url(forResource: name, withExtension: nameExtension) else {
            completion(false)
            return
        }
        
        
    }
}
