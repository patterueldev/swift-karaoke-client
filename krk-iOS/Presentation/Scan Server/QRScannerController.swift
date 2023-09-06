//
//  QRScannerController.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/3/23.
//

import UIKit
import AVFoundation

protocol QRScannerDelegate {
    func qrScannerDidScanSuccess(_ qrCode: String)
    func qrScannerDidScanFailure(_ error: Error)
}


class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    var delegate: AVCaptureMetadataOutputObjectsDelegate?
    var qrScannerDelegate: QRScannerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }

        let videoInput: AVCaptureDeviceInput

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            videoInput = try AVCaptureDeviceInput(device: captureDevice)

        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }

        // Set the input device on the capture session.
        captureSession.addInput(videoInput)

        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)

        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [ .qr ]

        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        // Start video capture.
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }

    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.captureSession.stopRunning()
 
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrScannerDelegate?.qrScannerDidScanFailure(NSError(domain: "No QR code detected", code: 0, userInfo: nil))
            return
        }
 
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
 
        if metadataObj.type == AVMetadataObject.ObjectType.qr,
           let result = metadataObj.stringValue {
 
            qrScannerDelegate?.qrScannerDidScanSuccess(result)
            print(result)
        }
    }
    
}
