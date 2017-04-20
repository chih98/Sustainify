//
//  contentViewController.swift
//  Sustainify
//
//  Created by Marko Crnkovic on 10/19/16.
//  Copyright © 2016 Marko Crnkovic. All rights reserved.
//

import UIKit

class contentViewController: UIViewController {
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var descriptionL: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    
    var imageFile: String!
    var titleText: String!
    var descriptionIndex: String!
    var pageIndex: Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        titleL.text = titleText!
        descriptionL.text = descriptionIndex!
        imageV.image = UIImage(named: self.imageFile!)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
