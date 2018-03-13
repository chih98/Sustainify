//
//  newRequestViewController.swift
//  Sustainify
//
//  Created by Marko Crnkovic on 10/7/16.
//  Copyright © 2016 Marko Crnkovic. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import alerter
import MapKit
class newRequestViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var reportConstraint: NSLayoutConstraint!
    @IBOutlet weak var reportTitle: UITextField!
    @IBOutlet weak var locationL: UITextField!
    @IBOutlet weak var detailedDescription: UITextView!
    @IBOutlet weak var urgentAction: UISwitch!
    @IBOutlet weak var issuePIcture: UIImageView!
    @IBOutlet weak var uSwitch: UISwitch!
    @IBOutlet weak var willbeAddedSoonL: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var reportB: UIButton!
    
    let theDef = UserDefaults.standard
    
    var lat: Double?
    var long: Double?
    var locationName: String?
    var didBegin = false
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lat = theDef.value(forKey: "userLocationLat") as? Double!
        long = theDef.value(forKey: "userLocationLong") as? Double!
        reportView.layer.cornerRadius = 25
        
        reportView.clipsToBounds = true
        
        imagePicker.delegate = self
        
        issuePIcture.layer.cornerRadius = 60
        issuePIcture.clipsToBounds = true
        
        detailedDescription.delegate = self
        
        reportConstraint.constant = self.view.frame.height + self.reportView.frame.height
        
        self.willbeAddedSoonL.alpha = 0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 0.5, animations: { 
                        self.reportView.center.y = self.view.center.y

            }) { (Bool) in
         
                self.reportConstraint.constant = 0
                
            }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if didBegin == false {
            didBegin = true
            self.detailedDescription.text = ""
            
        }
    }
    
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        dismissSegue()
    }
    @IBAction func dismissr(_ sender: AnyObject) {
        if reportTitle.isFirstResponder || locationL.isFirstResponder || detailedDescription.isFirstResponder {
            reportTitle.endEditing(true)
            locationL.endEditing(true)
            detailedDescription.endEditing(true)
        } else {
            dismissSegue()
        }
        
    }
    
    func dismissSegue() {
        UIView.animate(withDuration: 0.5, animations: {
            self.reportView.center.y = self.view.frame.height + self.reportView.frame.height
        }) { (Bool) in
            self.dismiss(animated: true, completion:nil)
        }

    }
    
    func completionChecker() -> Bool {
        
        if locationL.text == "" || detailedDescription.text == "" || reportTitle.text == "" || issuePIcture.image == UIImage(named: "Set Issue Pic") || didBegin == false {
            
            alerter(message: "Please Fill in All Fields", dark: true)
            
            return false
        } else {
            return true
        }
        
        
        
        
    }
    
    @IBAction func reportB(_ sender: AnyObject) {
        if completionChecker() == true {
          
            reportB.isEnabled = false
            reportB.setTitleColor(UIColor.gray, for: .normal)
            
            
           spinner.startAnimating()
            let obj = PFObject(className: "Reports")
            
            obj["title"] = reportTitle.text!
            obj["location"] = locationL.text!
            obj["description"] = detailedDescription.text!
            obj["lat"] = lat!
            obj["long"] = long! 
            obj["geopoint"] = PFGeoPoint(latitude: lat!, longitude: long!)
            obj["reference"] = PFUser.current()?.username ?? "Mistery Person"
            obj["orgName"] = self.locationName ?? "No Name Passed"
            obj["status"] = "Waiting For Review"
            
            let picture = PFFile(name: "cPicture.png", data: UIImageJPEGRepresentation(self.issuePIcture.image!, 0.03)!)
      
            obj["picture"] = picture!
            
            obj.saveInBackground(block: { (success, err) in
                if err == nil {
                    
                    self.spinner.stopAnimating()
                    self.rdismissr()
                    
                    
                } else {
                    self.spinner.stopAnimating()
                    self.willbeAddedSoonL.text = "Report failed to save, try again."
                    UIView.animate(withDuration: 0.5, animations: { 
                        self.willbeAddedSoonL.alpha = 1
                        }, completion: { (Bool) in
                            UIView.animate(withDuration: 0.5, animations: { 
                                self.willbeAddedSoonL.alpha = 0
                            })
                            
                            
                    })
                    
                self.willbeAddedSoonL.text = "This will be added soon!"
                
                    self.reportB.isEnabled = true
                    self.reportB.setTitleColor(UIColor.white, for: .normal)
                    
                }
            })

            
        }
    }
    
    func rdismissr() {
        UIView.animate(withDuration: 0.5, animations: {
            self.reportView.center.y = -self.view.frame.height
            }, completion: { (Bool) in
            alerter(message: "Report Sent", dark: true, success: true)
                
                self.dismiss(animated: true, completion: { 
                    
                
                    let currentInstallation = PFInstallation.current()
                    
                    currentInstallation?.addUniqueObject("USFCA", forKey: "channels")
                    
                    currentInstallation?.saveInBackground()
                    
                    PFCloud.callFunction(inBackground: "push", withParameters: ["channels": PFUser.current()?.object(forKey: "org") as? String ?? "none"]) { (any, err) in
                    if err == nil {
                       
                    } else {
                        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\(String(describing: err))\n\n\n\n\n\n\n\n\n\n\n\n\n")
                    }
                    
                }
               
            })
        })

    }
    
    
    @IBAction func urgentSwitch(_ sender: AnyObject) {
        
       UIView.animate(withDuration: 0.5, animations: { 
        self.willbeAddedSoonL.alpha = 1
        }) { (Bool) in
            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseInOut, animations: { 
                self.willbeAddedSoonL.alpha = 0
                }, completion: nil)
        }
        
        uSwitch.isOn = false
        
        
    }

    @IBAction func setPhoto(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Choose", message: "Choose how to add your profile picture.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            
            self.imagePicker.allowsEditing = false
            
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.issuePIcture.image = pickedImage
            dismiss(animated: true, completion: nil)
           
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
