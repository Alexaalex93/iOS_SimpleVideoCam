//
//  SimpleVideoCamController.swift
//  SimpleVideoCam
//
//  Created by Pablo Mateo Fernández on 02/02/2017.
//  Copyright © 2017 355 Berry Street S.L. All rights reserved.
//
import UIKit

class SimpleVideoCamController: UIViewController {

    @IBOutlet var cameraButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action methods
    
    @IBAction func unwindToCamera(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func capture(sender: AnyObject) {
    }


}
