//
//  ViewController.swift
//  Flicks
//
//  Created by MacbookPro on 1/9/16.
//  Copyright © 2016 MacbookPro. All rights reserved.
//

import UIKit
import AFNetworking
import Foundation
import SystemConfiguration

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
  
    @IBOutlet var networkError: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [NSDictionary]?
    var movie = NSDictionary()
    var refreshControl: UIRefreshControl!
    var netInfo : NSString = ""
    var endpoint = "";
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
                networkError.hidden = true
                collectionView.dataSource = self
                collectionView.delegate = self
         loadData()

  NSNotificationCenter.defaultCenter().addObserver(self,selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        collectionView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    



    func loadData() {
            let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
            let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
            let request = NSURLRequest(URL: url!)
            let session = NSURLSession(
                configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                delegate:nil,
                delegateQueue:NSOperationQueue.mainQueue()
            )
            
            let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                completionHandler: { (dataOrNil, response, error) in
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                                NSLog("response: \(responseDictionary)")
                                
                                self.movies = responseDictionary ["results"] as! [NSDictionary]
                                self.collectionView.reloadData()
                        }
                    }
            });
            task.resume()
            
            
            
        }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
   let currentObject1 = movies![indexPath.row]
        
        performSegueWithIdentifier("showMovieDetail", sender: currentObject1)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var currentObject1 : NSDictionary?
        if let movie = sender as? NSDictionary
        {
            currentObject1 = sender as? NSDictionary
        } else
        {
            
        }
        
        // Get a handle on the next story board controller and set the currentObject ready for the viewDidLoad method
        var detailScene = segue.destinationViewController as! DetailMovieViewController
        detailScene.currentObject1 = (currentObject1)
    }



    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        
  
        if let movies = movies {
            return movies.count
        } else {
            
            return 0
            
        }
    }
    
 
        
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("com.Davis.MovieCell", forIndexPath: indexPath) as! MovieCell
            let movie = movies![indexPath.row]
            let title = movie["title"] as! String
        
        
           let posterPath = movie["poster_path"] as! String
           let baseUrl = "http://image.tmdb.org/t/p/w500"
           let imageUrl = NSURL(string: baseUrl + posterPath)
        
        
         cell.titleLabel.text = title 
         cell.posterView.setImageWithURL(imageUrl!)
        
        
        
        
        return cell
    }




    
    func networkStatusChanged(notification: NSNotification) {
            let userInfo = notification.userInfo
           
            netInfo = userInfo! ["Status"] as! NSString
            if netInfo == "Online (WiFi)" {
               networkError.hidden = true
            } else {
            networkError.hidden = false
     
}
            
}
    
    
    func onRefresh() {
        
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
        Reach().monitorReachabilityChanges()
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }



}
