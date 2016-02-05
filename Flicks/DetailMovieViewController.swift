//
//  DetailMovieViewController.swift
//  
//
//  Created by MacbookPro on 1/18/16.
//
//

import UIKit
import AFNetworking
import Foundation
import SystemConfiguration

class DetailMovieViewController: UIViewController, UINavigationControllerDelegate  {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var overViewLabel: UILabel!
    var currentObject1: NSDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(currentObject1)
//        
//        let title = currentObject1!["title"] as! String
//        titleLabel.text = title
        let overView = currentObject1!["overview"] as! String
        overViewLabel.text = overView
        
        
        
        let posterPath = currentObject1!["poster_path"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        let data = NSData(contentsOfURL: imageUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check
  //      let image = UIImage(data: (data)!)
        //   var imageview =  UIImageView(image: image)
        //   self.view.addSubview(imageview)
        
        
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(data: data!)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleToFill
        
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
    
}
