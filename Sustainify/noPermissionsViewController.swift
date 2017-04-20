
//
//  noPermissionsViewController.swift
//  Sustainify
//
//  Created by Marko Crnkovic on 10/8/16.
//  Copyright © 2016 Marko Crnkovic. All rights reserved.
//

import UIKit
import MapKit
import alerter

class noPermissionsViewController: UIViewController {
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var authorizedL: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toSettings(_ sender: AnyObject) {
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }

    }

    @IBAction func checkPermissions(_ sender: AnyObject) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                notAuthorized()
                
            case .authorizedAlways, .authorizedWhenInUse:
                self.dismiss(animated: true, completion: nil)
               
            }
        } else {
            notAuthorized()
        }
        

        
    }

    func notAuthorized() {
        
      
        let alert = UIAlertController(title: "Oh no!", message: "Location services are still not enabled for Sustainify.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
