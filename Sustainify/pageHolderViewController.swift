//
//  welcomeViewController.swift
//  Sustainify
//
//  Created by Marko Crnkovic on 10/19/16.
//  Copyright © 2016 Marko Crnkovic. All rights reserved.
//

import UIKit

class pageHolderViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var welcomeViewConstraint: NSLayoutConstraint!
    
    @IBOutlet var bb: UIButton!
    
    
    var pageViewController: UIPageViewController!
    
    var pageTitles: NSArray!
    
    var pageDescrs: NSArray!
    
    var pageImages: NSArray!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeView.layer.cornerRadius = 25
        welcomeView.clipsToBounds = true
        
        bb.isEnabled = false
        
        
        
        self.pageTitles = NSArray(objects: "Welcome", "Reporting", "Feedback")
        
        self.pageDescrs = NSArray(objects: "With Sustainify, you can easily tell the right people about an issue in your community, right when you see it!", "You can easily submit reports when you see an issue, and we encourage you to do so! Please make sure that the issue hasnt been reported already. If you are flagged by producing duplicate reports, you will be banned.", "Please give us feedback! It's what we thrive on! Have an idea? Found a bug? Send us feedback with the purple button on the bottom right!")
        
        self.pageImages = NSArray(objects: "page1", "page2", "page3")
        
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        
        let startVC = self.viewControllerAtIndex(index: 0) as contentViewController
        
        let viewControllers = NSArray(object: startVC)
        
        
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        
        
        
        
        
        
        self.addChildViewController(self.pageViewController)
        
        self.view.addSubview(self.pageViewController.view)
        
        self.pageViewController.didMove(toParentViewController: self)
        
        pageViewController.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.welcomeView.center.y = self.view.center.y
            
        }) { (Bool) in
            
            self.welcomeViewConstraint.constant = 0
            
        }
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        pageViewController.view.layer.cornerRadius = 25
        pageViewController.view.clipsToBounds = true
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.welcomeView.frame.width, height: self.welcomeView.frame.height)

        
        self.pageViewController.view.center = CGPoint(x: self.welcomeView.center.x, y: self.welcomeView.center.y - self.bb.frame.height)
        
    }
    
    func viewControllerAtIndex(index: Int) -> contentViewController
        
    {
        
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            
            return contentViewController()
            
        }
        
        if index == self.pageTitles.count - 1 {
            
            setButton(enabled: true)
            
        } else {
            
            setButton(enabled: false)
        }
        
        
        
        let vc: contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! contentViewController
        
        
        
        vc.imageFile = self.pageImages[index] as! String
        
        vc.titleText = self.pageTitles[index] as! String
        
        vc.descriptionIndex = self.pageDescrs[index] as! String
        
        vc.pageIndex = index
        
        
        
        return vc
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
        
    {
        
        
        
        let vc = viewController as! contentViewController
        
        var index = vc.pageIndex as Int
        
        
        
        
        
        if (index == 0 || index == NSNotFound)
            
        {
            
            return nil
            
            
            
        }
        
        
        
        index -= 1
        
        return self.viewControllerAtIndex(index: index)
        
        
        
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        
        let vc = viewController as! contentViewController
        
        var index = vc.pageIndex as Int
        
        
        
        if (index == NSNotFound)
            
        {
            
            return nil
            
        }
        
        
        
        index += 1
        
        
        
        if (index == self.pageTitles.count)
            
        {
            
            return nil
            
        }
        
        
        
        return self.viewControllerAtIndex(index: index)
        
        
        
    }
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
        
    {
        
        return self.pageTitles.count
        
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
        
    {
        
        return 0
        
    }
    
    
    
    @IBAction func bottomButton(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.welcomeView.center.y = self.view.frame.height + self.welcomeView.center.y
            
            self.pageViewController.view.center.y = self.view.frame.height + self.pageViewController.view.center.y
            
        }) { (Bool) in
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func setButton(enabled: Bool) {
        
        if enabled == true {
            
            bb.isEnabled = true
            bb.setTitle("Done", for: .normal)
            
        } else {
            self.bb.isEnabled = false
            self.bb.setTitle("Swipe to Continue", for: .normal)
        }
        
        
        
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
