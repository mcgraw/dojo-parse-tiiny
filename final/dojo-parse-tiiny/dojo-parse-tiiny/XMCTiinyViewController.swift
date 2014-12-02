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
    
    var images: NSMutableArray = NSMutableArray()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            return collectionView.dequeueReusableCellWithReuseIdentifier("cameraCellIdentifier", forIndexPath: indexPath) as XMCCameraCollectionViewCell
        }
        
        var cell: XMCPhotoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCellIdentifier", forIndexPath: indexPath) as XMCPhotoCollectionViewCell
        
        var item: AnyObject = self.images.objectAtIndex(indexPath.row-1)
        if item.isKindOfClass(UIImage) {
            cell.setPhotoWithImage(self.images.objectAtIndex(indexPath.row-1) as? UIImage)
        } else {
            cell.setPhotoWithUrlPath(self.images.objectAtIndex(indexPath.row-1) as String)
        }
        
        return cell
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        var camera: XMCCameraCollectionViewCell = photoCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as XMCCameraCollectionViewCell
        camera.captureFrame { (image) -> Void in
            if let still = image {
                self.images.addObject(still)
                self.photoCollectionView.reloadData()
            }
        }
    }
}

