//
//  XMCCameraCollectionViewCell.swift
//  dojo-parse-tiiny
//
//  Created by David McGraw on 12/2/14.
//  Copyright (c) 2014 David McGraw. All rights reserved.
//

import UIKit
import AVFoundation

class XMCCameraCollectionViewCell: UICollectionViewCell, XMCCameraDelegate {
    
    @IBOutlet weak var cameraPreview: UIView!
    
    var preview: AVCaptureVideoPreviewLayer?
    
    var camera: XMCCamera?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Create our camera object
        self.camera = XMCCamera(sender: self)
        
        // We don't need a full resolution image
        self.camera?.session.sessionPreset = AVCaptureSessionPreset352x288
    }
    
    func initializePreviewLayer() {
        // Establish our preview layer
        self.preview = AVCaptureVideoPreviewLayer(session: self.camera?.session)
        self.preview?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.preview?.frame = self.cameraPreview.bounds
        self.cameraPreview.layer.addSublayer(self.preview)
    }
    
    func captureFrame(completed: (image: UIImage?) -> Void) {
        self.camera?.captureStillImage({ (image) -> Void in
            if image != nil {
                completed(image: image);
            } else {
                completed(image: nil)
            }
        })
    }
    
    // MARK: Camera Delegate
    
    func cameraSessionConfigurationDidComplete() {
        self.camera?.startCamera()
    }
    
    func cameraSessionDidBegin() {
        // perform any work that needs to be completed when the camera starts
        self.initializePreviewLayer()
    }
    
    func cameraSessionDidStop() {
        // perform any work that needs to be completed when the camera stops
    }
}