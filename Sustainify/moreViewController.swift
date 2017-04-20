//
//  moreViewController.swift
//  Sustainify
//
//  Created by Marko Crnkovic on 10/8/16.
//  Copyright © 2016 Marko Crnkovic. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class moreViewController: UIViewController {
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var moreConstant: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        moreConstant.constant = self.view.frame.height + self.moreView.frame.height
        
        moreView.layer.cornerRadius = 25
        moreView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5, animations: {
            self.moreView.center.y = self.view.center.y
            
        }) { (Bool) in
            
            self.moreConstant.constant = 0
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func done(_ sender: AnyObject) {
        dismisrr()
    }
    
    func dismisrr() {
        UIView.animate(withDuration: 0.5, animations: {
            self.moreView.center.y = self.view.frame.height + self.moreView.frame.height
        }) { (Bool) in
            self.dismiss(animated: true, completion: nil)
        }
        
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
