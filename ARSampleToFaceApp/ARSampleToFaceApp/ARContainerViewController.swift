//
//  ARContainerViewController.swift
//  ARSampleToFaceApp
//
//  Created by Oh!ara on 2023/08/14.
//

import UIKit
import RealityKit
import ARKit
import Combine


class ARContainerViewController: UIViewController {
    
    // MARK: - UI
    // MARK: - 変数
    
    var arView: ARView!
    
    var sphere: VirtureObject?
    
    var coachingOverlay = ARCoachingOverlayView()
    
    var sphereCardAnchor: AnchorEntity?
    
    // 光源
    var light: PointLight?
    
    var lightAnchor: AnchorEntity?
    var lightImage: AnchorEntity?
    
    
    var collisionBegan: Cancellable?
    
    // MARK: - ライフサイクル
    
    override func loadView() {
        self.view = UIView(frame: .zero)
        
        setUp()
            
        setupCoachingOverlay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
        
        resetTracking()
        
        
    }
    
    
    // MARK: - 関数
    
    func setUp() {
        
        // arviewの生成
        arView = ARView(
            frame: .zero,
            cameraMode: .ar,
            automaticallyConfigureSession: false
        )
        
        arView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arView)
        
        // 上下左右にフィット
        NSLayoutConstraint.activate([
            arView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            arView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            arView.widthAnchor.constraint(equalTo: view.widthAnchor),
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // デリゲート
        arView.session.delegate = self
    }
    
   
    
  
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else {
            return
        }
        
        var message = (error as NSError).localizedRecoverySuggestion
        if  let reason = (error as NSError).localizedFailureReason {
            message! += "\n\(reason)"
        }
        
        if let suggestion = (error as NSError).localizedRecoverySuggestion {
            message! += "\n\(suggestion)"
        }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "ARSession Failed", message: message, preferredStyle: .alert)
            
            let reset = UIAlertAction(title: "reset", style: .default) { _ in
                self.resetTracking()
            }
            
            alert.addAction(reset)
            self.present(alert, animated: true)
        }
        
    }
   
    
    func resetTracking() {
        
        arView.environment.sceneUnderstanding.options = [.collision]
        
        let config = ARWorldTrackingConfiguration()
        
        config.planeDetection = [.horizontal]
        
        config.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        
        arView.session.run(config, options: [.removeExistingAnchors, .resetTracking])
        
        collisionBegan = arView.scene.subscribe(to: CollisionEvents.Began.self, onCollisionBegan(_:))
    }
    

    
    func sessionWasInterrupted(_ session: ARSession) {
       
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
//        resetTracking()
    }
    
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
       
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return false
    }
    
    func onCollisionBegan(_ event: CollisionEvents.Began) {
        
    }

    func addPlane() -> AnchorEntity {
        let plane = AnchorEntity()
        
        arView.scene.addAnchor(plane)
        
        return plane
    }
}

// MARK: - extension


extension ARContainerViewController: ARSessionDelegate {
    
   
    
    func setupCoachingOverlay() {
        coachingOverlay.session = arView.session
        
        coachingOverlay.delegate = self
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        arView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: arView.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: arView.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: arView.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: arView.heightAnchor)
            ])
        
        coachingOverlay.activatesAutomatically = true
        
        coachingOverlay.goal = .horizontalPlane
    }
    
    
}


extension ARContainerViewController: ARCoachingOverlayViewDelegate {
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
       
        resetTracking()
    }
    
}


