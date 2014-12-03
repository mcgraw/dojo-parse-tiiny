//
//  XMCTiinyViewController.swift
//  dojo-parse-tiiny
//
//  Created by David McGraw on 12/2/14.
//  Copyright (c) 2014 David McGraw. All rights reserved.
//

import UIKit

class XMCTiinyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    @IBOutlet weak var capturePhoto: UIButton!
    
    var cameraCellReference: XMCCameraCollectionViewCell?
    
    var images: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshLayout()
    }
    
    func refreshLayout() {
        let query = PFQuery(className: "XMCPhoto")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            // jump back to  the background process the results
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                for (index, value) in enumerate(objects) {
                    let photoObj = value as PFObject
                    let image: PFFile = photoObj["image"] as PFFile
                    let imageData = image.getData()
                    
                    // be sure to send the results back to our main thread
                    dispatch_async(dispatch_get_main_queue()) {
                        self.images.addObject(UIImage(data: imageData)!)
                    }
                }
            
                // refresh the collection
                dispatch_async(dispatch_get_main_queue()) {
                    self.photoCollectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: Collection View
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            cameraCellReference = collectionView.dequeueReusableCellWithReuseIdentifier("cameraCellIdentifier", forIndexPath: indexPath) as? XMCCameraCollectionViewCell
            return cameraCellReference!
        }
        
        var cell: XMCPhotoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCellIdentifier", forIndexPath: indexPath) as XMCPhotoCollectionViewCell
        var position = self.images.count - indexPath.row
        cell.setPhotoWithImage(self.images.objectAtIndex(position) as? UIImage)
        
        return cell
    }
    
    // MARK: Flow Layout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var value = UIScreen.mainScreen().bounds.width
        value = (value/3.0) - 4
        return CGSizeMake(value, value)
    }
    
    // MARK: Actions
    
    @IBAction func takePhoto(sender: AnyObject) {
        cameraCellReference?.captureFrame { (image) -> Void in
            if let still = image {
                
                // assume success so that the user will not encounter more lag than needed
                self.images.addObject(still)
                self.photoCollectionView.insertItemsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)])
                
                // send the image to parse
                var file: PFFile = PFFile(data: UIImageJPEGRepresentation(still, 0.7))
                file.saveInBackgroundWithBlock({ (success, fileError) -> Void in
                    if success {
                        var object: PFObject = PFObject(className: "XMCPhoto")
                        object["image"] = file
                        object.saveInBackgroundWithBlock({ (success, objError) -> Void in
                            if success {
                                println("Photo object saved")
                            } else {
                                println("Unable to create a photo object: \(objError)")
                            }
                        })
                    } else {
                        println("Unable to save file: \(fileError)")
                    }
                })
                
                /*  NOTE: in the even that the code above fails, you want to revert
                    our photo addition and then alert the user. 
                
                    OR, create an upload manager that will retry the upload attempt.
                 */
            }
        }
    }
    
    // MARK: Gesture Actions
    
    @IBAction func doubleTappedCollection(sender: AnyObject) {
        var point = sender.locationInView(self.photoCollectionView)
        var indexPath = self.photoCollectionView.indexPathForItemAtPoint(point)
        if indexPath?.row > 0 {
            println("Double Tapped Photo At Index \(indexPath!.row-1)")
        }
    }
    
}

