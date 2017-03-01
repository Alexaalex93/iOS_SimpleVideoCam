//
//  SimpleVideoCamController.swift
//  SimpleVideoCam
//
//  Created by Pablo Mateo Fernández on 02/02/2017.
//  Copyright © 2017 355 Berry Street S.L. All rights reserved.
//
import UIKit
import AVFoundation
import AVKit

class SimpleVideoCamController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    @IBOutlet var cameraButton:UIButton!
    
    let captureSession = AVCaptureSession()
    var currentDevice: AVCaptureDevice?
    var videoFIleOutput: AVCaptureMovieFileOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        if let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInDuoCamera, mediaType: AVMediaTypeVideo, position: .back){
        currentDevice = device
        } else if let device = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back){
            currentDevice = device
        } else {
        //Fallback on earlier versions

        }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else { return }
        
        videoFIleOutput = AVCaptureMovieFileOutput()
        
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(videoFIleOutput)
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        view.bringSubview(toFront: cameraButton)
        captureSession.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action methods
    
    @IBAction func unwindToCamera(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func capture(sender: AnyObject) {
        
        if !isRecording {
            isRecording = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: { self.cameraButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5) }, completion: nil)
            
            let outputPath = NSTemporaryDirectory() + "output.mov"
            let outputFileURL = URL(fileURLWithPath: outputPath)
            videoFIleOutput?.startRecording(toOutputFileURL: outputFileURL, recordingDelegate: self)//Empezamos a grabar en esta direccion con este delegado
        } else {
        
            isRecording = false
            /*UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
                self.cameraButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: nil)
            cameraButton.layer.removeAllAnimations()
*/
            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
                 self.cameraButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { (completed) in
                    self.cameraButton.layer.removeAllAnimations()
            })
            videoFIleOutput?.stopRecording()
        
        }
    }
    

    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        performSegue(withIdentifier: "playVideo", sender: outputFileURL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playVideo" {
        
            let videoPlayerViewController = segue.destination as! AVPlayerViewController
            let videoFileURL = sender as! NSURL
            videoPlayerViewController.player = AVPlayer(url: videoFileURL as URL)
            
        }
    }
}

