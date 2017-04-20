//
//  ViewController.swift
//  Sustainify
//
//  Created by Marko Crnkovic on 10/4/16.
//  Copyright © 2016 Marko Crnkovic. All rights reserved.
//

import UIKit
import Parse
import alerter
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4
import FacebookCore
import FacebookLogin
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  FBSDKLoginButtonDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var firstNameL: UITextField!
    @IBOutlet weak var lastNameL: UITextField!
    @IBOutlet weak var userNameL: UITextField!
    @IBOutlet weak var emailL: UITextField!
    @IBOutlet weak var passwordL: UITextField!
    @IBOutlet weak var profilePicHolder: UIImageView!
    @IBOutlet weak var prompt: UILabel!
    let locationManager = CLLocationManager()
    
     let imagePicker = UIImagePickerController()
   
    var changed = false
    var imagePicked = false
    var user: NSDictionary!
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
                 
            
       
            locationManager.delegate = self
            
        profilePicHolder.layer.cornerRadius = 64
        profilePicHolder.clipsToBounds = true
        
            imagePicker.delegate = self
            
        let fbLogInButton: FBSDKLoginButton = {
       
            let button = FBSDKLoginButton()
        
        button.readPermissions = ["public_profile", "email"]
        
        return button

    }()
            
            view.addSubview(fbLogInButton)
            fbLogInButton.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
            
            fbLogInButton.delegate = self
            
            
            
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var signUpConstraint: NSLayoutConstraint!
    
    func setProfile() {
     
        
        if user.value(forKey: "first_name") != nil {
        firstNameL.text = "\(user.value(forKey: "first_name")!)"
        }
        
        if user.value(forKey: "last_name") != nil {
        lastNameL.text = "\(user.value(forKey: "last_name")!)"
        }
        
        if user.value(forKey: "email") != nil {
            changed = true
        emailL.text = "\(user.value(forKey: "email")!)"
            
            self.acctChecker()
            
           
        }
        
        if user.value(forKey: "picture") != nil {
            
           let pictureObject = user.value(forKey: "picture")! as! NSDictionary
            let pictureData = pictureObject.value(forKey: "data")! as! NSDictionary
            let url = "\(pictureData.value(forKey: "url")!)"
            
            let picURL = NSURL(string: url)
            
            let data = NSData(contentsOf: picURL! as URL!)
            
            profilePicHolder.image = UIImage(data: data as! Data)
            
            imagePicked = true
            
            
            
            
            
        }
        
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if result.isCancelled != true {
        
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,last_name,picture.type(large)"], tokenString: result.token.tokenString, version: nil, httpMethod: "GET")
        req!.start(completionHandler: { (connection, result, error) -> Void in
            if(error == nil)
            {
                print("result \(result!)")
                FBSDKLoginManager().logOut()
                loginButton.isHidden = true
                self.prompt.text = "Please fill in all fields"
                self.user = (result as? NSDictionary)!
               
                self.setProfile()
            }
            else
            {
                print("error \(error)")
            }
        })
        }
        
        }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("\n\n\n\n\n\n\n\n\n\n\n\n\nLogged Out")
    }
    
    func acctChecker() {
        let query = PFQuery(className: "_User")
        
        query.whereKey("email", equalTo: self.emailL.text!)
        
        
        query.getFirstObjectInBackground(block: { (obj, err) in
            if obj == nil && err?._code == 101 {
                
                self.buttonArr(result: false)
                
            } else if obj != nil && err == nil {
                self.userNameL.text = obj!["username"] as? String!
                
                self.buttonArr(result: true)
            } else {
                
            }
        })
 
    }
  
    
    @IBAction func emailDidEndOnExi(_ sender: AnyObject) {
            let query = PFQuery(className: "_User")
            
            query.whereKey("email", equalTo: self.emailL.text!)
           
            
          query.getFirstObjectInBackground(block: { (obj, err) in
            if obj == nil && err?._code == 101 {
                
                self.buttonArr(result: false)
         
            } else if obj != nil && err == nil {
               self.userNameL.text = obj!["username"] as? String!
                self.buttonArr(result: true)
            } else {
                
            }
          })
        
    }
    
    @IBAction func editingDidEndd(_ sender: AnyObject) {
         let query = PFQuery(className: "_User")
        query.whereKey("email", equalTo: self.emailL.text!)
        
        
        query.getFirstObjectInBackground(block: { (obj, err) in
            if obj == nil && err?._code == 101 {
                
                self.buttonArr(result: false)
                
            } else if obj != nil && err == nil {
                
               self.userNameL.text = obj!["username"] as? String!
                self.buttonArr(result: true)
            } else {
                
            }
        })
    }
    
    
    
    
    @IBOutlet weak var equalsConstraint: NSLayoutConstraint!
    @IBOutlet weak var logInConstraint: NSLayoutConstraint!
    
    func buttonArr(result: Bool!) {
      
        if (self.equalsConstraint != nil) {
        
        self.equalsConstraint.isActive = false
            
        }
        
        if result! == false {
            
            
            UIView.animate(withDuration: 0.5, animations: {
               
               

               self.signUpConstraint.constant = self.view.frame.width
                
            })
            
        } else if result! == true {
            UIView.animate(withDuration: 0.5, animations: { 
              
                
                self.logInConstraint.constant = self.view.frame.width
        })
        } else if result == nil {
            self.equalsConstraint.isActive = true
        }
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fieldChecker(field: String) -> Bool {
        if field == "signup" {
            
        if firstNameL.text == "" || lastNameL.text == "" || userNameL.text == "" || emailL.text == "" || passwordL.text == "" || imagePicked == false {
            
            
            alerter(message: "Fill in all fields!", dark: true)
            return false
            
        } else { return true }}  else if field == "signin" {
            
            if userNameL.text == "" || passwordL.text == "" {
            alerter(message: "Enter both username and password", dark: true)
                return false
            } else {return true}
            }
            
        
       
            return true
        
    }
    
   
    // MARK: - TFDD
    
    
    
    

    
    @IBAction func parseSignUp(_ sender: AnyObject) {
        
        if fieldChecker(field: "signup") == true {
            
            let user = PFUser()
            
            user["firstName"] = firstNameL.text
            user["lastName"] = lastNameL.text
            user["admin"] = false
            user["type"] = "user"
            user["leader"] = false
            user["org"] = ""
            user.username = userNameL.text
            user.email = emailL.text
            user.password = passwordL.text
            
            let picture = PFFile(name: "cPicture.png", data: UIImageJPEGRepresentation(self.profilePicHolder.image!, 0.5)!)
            
           
            user["picture"] = picture!
            
            user.signUpInBackground(block: { (success, err) in
                if err == nil {
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                } else {
                    
                    alerter(message: "\(err!.localizedDescription)", dark: true)
                    
                }
            })
           
            
        }
        
        
    }
    
    @IBAction func parseSignIn(_ sender: AnyObject) {
        if fieldChecker(field: "signin") == true {
        
            PFUser.logInWithUsername(inBackground: self.userNameL.text!, password: self.passwordL.text!, block: { (usr, err) in
                if err == nil {
                    
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                    
                } else {
                    alerter(message: "\(err!.localizedDescription)", dark: true)
                }
            })
            
            
            
            
        }
    }
    
    // MARK: - Image Picture
    
    
    @IBAction func setProfilePic(_ sender: AnyObject) {
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
            self.profilePicHolder.image = pickedImage
            dismiss(animated: true, completion: nil)
            self.imagePicked = true
        }
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func dismissr(_ sender: AnyObject) {
        firstNameL.endEditing(true)
        lastNameL.endEditing(true)
        userNameL.endEditing(true)
        emailL.endEditing(true)
        passwordL.endEditing(true)
    }

}

