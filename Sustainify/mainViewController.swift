//
//  mainViewController.swift
//  Sustainify
//
//  Created by Marko Crnkovic on 10/6/16.
//  Copyright © 2016 Marko Crnkovic. All rights reserved.
//

import UIKit
import Parse
import MapKit
import alerter

class mainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var reportB: UIButton!
    
    let theDef = UserDefaults.standard
    let locationManager = CLLocationManager()
    var canPost = false
    
    var orgName: String = ""
    
    @IBOutlet weak var feedbackb: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.delegate = self
        
        reportB.isEnabled = false
        reportB.setTitleColor(.gray, for: .normal)
        
        feedbackb.layer.cornerRadius = 27.5
        feedbackb.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        
        
        if theDef.bool(forKey: "welcomed") != true {
            
            performSegue(withIdentifier: "toWelcome", sender: nil)
            theDef.set(true, forKey: "welcomed")
        }
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                
                locationManager.requestWhenInUseAuthorization()
                
                
            case .restricted, .denied:
                performSegue(withIdentifier: "toNoLocation", sender: nil)
                
            case .authorizedAlways, .authorizedWhenInUse:
                
                delay(bySeconds: 1.5, dispatchLevel: .background) {
                    self.zoomInToUser()
                }
            }
        } else {
            performSegue(withIdentifier: "toNoLocation", sender: nil)
        }
        
        
    }
    
    
    func reportPoints() {
        
        var lats: [Double?] = []
        var longs: [Double?] = []
        var titles: [String?] = []
        var subtitles: [String?] = []
        
        let query = PFQuery(className: "Reports")
        query.whereKey("status", notEqualTo: "Resolved")
        query.findObjectsInBackground { (downloadedObjs, err) in
            
            let count = downloadedObjs?.count ?? 0
            
            for i in 0..<count {
                
                lats.append(downloadedObjs?[i]["lat"] as? Double)
                longs.append(downloadedObjs?[i]["long"] as? Double)
                titles.append(downloadedObjs?[i]["title"] as? String)
                subtitles.append(downloadedObjs?[i]["location"] as? String)
                
            }
            
            
            let lCount = lats.count
            
            var annotations: [MKAnnotation] = []
            
            var n = 0
            
            while n != lCount {
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = CLLocationCoordinate2DMake(lats[n]!, longs[n]!)
                annotation.title = titles[n]!
                annotation.subtitle = subtitles[n]!
                
                
                annotations.append(annotation)
                
                n += 1
                
            }
            
            self.mapView.addAnnotations(annotations)
            
            
            self.locationManager.stopUpdatingLocation()
            self.searchReigon()
            
        }
        
        
        
        
    }
    
    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate
        userLocation: MKUserLocation) {
        mapView.centerCoordinate = (userLocation.location?.coordinate)!
        
        theDef.set((userLocation.location?.coordinate.latitude)! as Double!, forKey: "userLocationLat")
        theDef.set((userLocation.location?.coordinate.longitude)! as Double!, forKey: "userLocationLong")
        
        self.reportB.isEnabled = true
        self.reportB.setTitleColor(.white, for: .normal)
    }
    
    
    func zoomInToUser() {
        let userLocation = mapView.userLocation
        
        if (userLocation.location != nil) {
            
            let region = MKCoordinateRegionMakeWithDistance(
                (userLocation.location?.coordinate)!, 500, 500)
            
            mapView.setRegion(region, animated: true)
            self.reportPoints()
        }
    }
    
    @IBAction func locateUser(_ sender: AnyObject) {
        
        zoomInToUser()
        
    }
    
    @IBAction func reportB(_ sender: AnyObject) {
        
        if canPost ==  true {
            
            performSegue(withIdentifier: "toReport", sender: nil)
            
        } else {
            
            alerter(message: "You are in an unsupported reigon", dark: true, success: false)
            
        }
        
    }
    
    func saved() {
        
        alerter(message: "Report Sent", dark: true, success: true)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toReport" {
            
            let vc = segue.destination as? newRequestViewController
            
            vc!.locationName = orgName ?? "No Name"
            
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func logOutButton(_ sender: AnyObject) {
        
        PFUser.logOutInBackground { (err) in
            if err == nil {
                
                let vc = self.storyboard?.instantiateInitialViewController()
                
                self.present(vc!, animated: true, completion: nil)
                
            } else {
                
                alerter(message: err!.localizedDescription, dark: true)
                
                
            }
        }
        
    }
    
    
    
    func searchReigon() {
        
        let cl = mapView.userLocation.coordinate
        
        let geopoint = PFGeoPoint(latitude: cl.latitude, longitude: cl.longitude)
        
        let query = PFQuery(className: "Schools")
        
        query.findObjectsInBackground { (objs, err) in
            if err == nil {
                
                var cp = false
                
                for org in objs! {
                    
                    let loc = org["location"] as! PFGeoPoint
                    let rad = org["radius"] as! Double
                    
                    if geopoint.distanceInKilometers(to: loc) < rad {
                        
                        cp = true
                        self.orgName = org["name"] as! String
                        
                    }
                    
                }
                
                if cp == true {
                    
                    self.canPost = true
                    
                    
                } else {
                    
                    alerter(message: "Not in Supported Reigon", dark: true, success: false)
                }
                
            }
        }
        
    }
    
    // MARK: - Downloading Markers
    
    
    
    
    
    
}
