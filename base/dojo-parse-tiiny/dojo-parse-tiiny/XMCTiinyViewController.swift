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
        var camera: XMCCameraCollectionViewCell = photoCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as XMCCameraCollectionViewCell
        camera.captureFrame { (image) -> Void in
            if let still = image {
                self.images.addObject(still)
                self.photoCollectionView.insertItemsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)])
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

