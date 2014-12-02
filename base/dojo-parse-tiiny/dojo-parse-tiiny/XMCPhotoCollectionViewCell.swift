//
//  XMCPhotoCollectionViewCell.swift
//  dojo-parse-tiiny
//
//  Created by David McGraw on 12/2/14.
//  Copyright (c) 2014 David McGraw. All rights reserved.
//

import UIKit
import Foundation

class XMCPhotoCollectionViewCell: UICollectionViewCell, NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var photo: UIImageView!
    
    func setPhotoWithImage(image: UIImage?) {
        if image != nil {
            self.photo.image = image;
        }
    }
    
    func setPhotoWithUrlPath(path: NSString) {
        let url = NSURL(string: path)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithURL(url!)
        task.resume()
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        var data: NSData = NSData(contentsOfURL: location)!
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.setPhotoWithImage(UIImage(data: data)?)
        })
    }
}
