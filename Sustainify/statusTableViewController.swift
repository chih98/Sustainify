//
//  statusTableViewController.swift
//  
//
//  Created by Marko Crnkovic on 10/8/16.
//
//

import UIKit
import Parse
import ParseUI
class statusTableViewController: PFQueryTableViewController {
    
    var list = [PFObject]()
    
    
    
    @IBOutlet var statusTableView: UITableView!
   
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //MARK: Add className
        // Configure the PFQueryTableView
        
        self.parseClassName = "Reports"
        self.textKey = "reference"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    
    override func queryForTable() -> PFQuery<PFObject> {
        //MARK: Add className
        
        let query = PFQuery(className: "Reports")
       
        query.whereKey("reference", equalTo: PFUser.current()!.username!)
        query.order(byDescending: "createdAt")
        return query
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusTableView.delegate = self
        statusTableView.dataSource = self
        statusTableView.allowsSelection = false
        
    
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> PFTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customStatusCell
        
        cell.title.text = object?["title"] as? String
        cell.reviewStatus.text = object?["status"] as? String
        
        if object?["status"] as? String == "Waiting For Review" {
            cell.reviewStatus.textColor = UIColor.orange
        } else if object?["status"] as? String == "In Progress" {
            cell.reviewStatus.textColor = UIColor.green
        } else if object?["status"] as? String == "Denied" {
            cell.reviewStatus.textColor = UIColor.red
        }else if object?["status"] as? String == "Resolved" {
            cell.reviewStatus.textColor = UIColor.cyan
        }
        
        
        // Configure the cell...
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toDetail", sender: nil)
        
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
   
    
    
    
}
