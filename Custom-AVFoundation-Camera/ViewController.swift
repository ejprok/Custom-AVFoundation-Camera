//
//  ViewController.swift
//  Custom-AVFoundation-Camera
//
//  Created by Edward Prokopik on 3/24/20.
//  Copyright © 2020 Edward Prokopik. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCapturePhotoOutput?

    @IBOutlet weak var previewImage: UIImageView!
    
    @IBAction func takePictureButton(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        cameraCaptureOutput?.capturePhoto(with: settings, delegate: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCaptureSession()
    }

    func initCaptureSession() {
        session.sessionPreset = AVCaptureSession.Preset.high
        camera = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            if let availableCamera = camera {
                let cameraCaptureInput = try AVCaptureDeviceInput(device: availableCamera)
                cameraCaptureOutput = AVCapturePhotoOutput()

                session.addInput(cameraCaptureInput)
                session.addOutput(cameraCaptureOutput!)

            } else {
                print("no available camera")
            }
        } catch {
            print(error.localizedDescription)
        }

        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        let bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / 1.5)
        
        cameraPreviewLayer?.frame =  bounds

        if let layer = cameraPreviewLayer {
            view.layer.insertSublayer(layer, at: 0)
        }
        session.startRunning()
    }


}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let unwrappedError = error {
            print(unwrappedError.localizedDescription)
        } else {
            print("image captured")
            let image = photo.fileDataRepresentation()
            previewImage.image = UIImage(data: image!)
        }
    }
}

