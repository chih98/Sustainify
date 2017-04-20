//
//  bugReportViewController.swift
//  Sustainify
//
//  Created by Marko Crnkovic on 10/19/16.
//  Copyright © 2016 Marko Crnkovic. All rights reserved.
//

import UIKit
import ParseUI
import alerter
class bugReportViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var bugView: UIView!
    @IBOutlet weak var bugConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleL: UITextField!
    @IBOutlet weak var descriptionL: UITextView!
    @IBOutlet weak var chooser: UISegmentedControl!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var didBegin = false

    override func viewDidLoad() {
        super.viewDidLoad()

        bugView.layer.cornerRadius = 25
        
        bugView.clipsToBounds = true
        
        bugConstraint.constant = self.view.frame.height + self.bugView.frame.height
        
        descriptionL.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bugView.center.y = self.view.center.y
            
        }) { (Bool) in
            
            self.bugConstraint.constant = 0
            
        }
        
    }
    
    
    func completionChecker() -> Bool {
        
        if titleL.text == "" || descriptionL.text == "" || didBegin == false {
        
            return false
        } else {
            return true
        }
        
        
        
        
    }

 
    func textViewDidBeginEditing(_ textView: UITextView) {
        if didBegin == false {
            didBegin = true
            self.descriptionL.text = ""
            
        }
    }
    
    
    @IBAction func dismissr(_ sender: AnyObject) {
        
        if titleL.isFirstResponder || descriptionL.isFirstResponder {
                titleL.endEditing(true)
                descriptionL.endEditing(true)
                } else {
                dismissSegue()
            }
 
    }

    func dismissSegue() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bugView.center.y = self.view.frame.height + self.bugView.frame.height
        }) { (Bool) in
            self.dismiss(animated: true, completion:nil)
        }
        
    }
    
    @IBAction func reportB(_ sender: AnyObject) {
    
        print(completionChecker())
        
        if completionChecker() == true {
            print("started")
            let obj = PFObject(className: "Bugs")
            
            obj["title"] = titleL.text!
            
            obj["description"] = descriptionL.text!
            
            if chooser.selectedSegmentIndex == 0 {
               
                obj["type"] = "bug"
                
            } else if chooser.selectedSegmentIndex == 1 {
                
                obj["type"] = "idea"
                
            }
            
            obj.saveInBackground(block: { (done, err) in
                self.spinner.startAnimating()
                
                if err == nil {
                    
                    if done == true {
                        
                        self.rdismissr()
                        
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Error", message: "An unknown error occured, try again.", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                } else {
                    
                    let alert = UIAlertController(title: "Error", message: "                    \(err!.localizedDescription)", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
             self.spinner.stopAnimating()
                
            })
    
    
        }
    
    }
    
    
    
    
    func rdismissr() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bugView.center.y = -self.view.frame.height
            }, completion: { (Bool) in
                alerter(message: "Report Sent", dark: true, success: true)
                
                self.dismiss(animated: true, completion: {                    
                    
                    
                    PFCloud.callFunction(inBackground: "devpush", withParameters: nil) { (any, err) in
                        if err == nil {
                            
                        } else {
                            print("\n\n\n\n\n\n\n\n\n\n\n\n\n\(err)\n\n\n\n\n\n\n\n\n\n\n\n\n")
                        }
                        
                    }
                    
                })
        })
        
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
