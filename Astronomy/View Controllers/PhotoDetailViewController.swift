//
//  PhotoDetailViewController.swift
//  Astronomy
//
//  Created by Andrew R Madsen on 9/9/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Photos

class PhotoDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else { return }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { (success, error) in
            if let error = error {
                NSLog("Error saving photo: \(error)")
                return
            }
        })
    }
    
    // MARK: - Private
    
    private func updateViews() {
        guard let photo = photo, isViewLoaded else { return }
        // Approach #1
//        do {
//            let data = try Data(contentsOf: photo.imageURL.usingHTTPS!)
//            let filtered = UIImage(data: data)?.filtered()
//            DispatchQueue.main.async {
//                self.imageView.image = filtered
//            }
//        } catch {
//            NSLog("Error setting up views on detail view controller: \(error)")
//        }
    
        
        // Approach #2
        let fetchOp = FetchPhotoOperation(photoReference: photo)
        let filterOp = FilterImageOperation(fetchPhotoOperation: fetchOp)
        filterOp.addDependency(fetchOp)
        let updateImageViewOp = BlockOperation {
            if let image = filterOp.filteredImage {
                self.imageView.image = image
            }
        }
        updateImageViewOp.addDependency(filterOp)
        operationQueue.addOperation(fetchOp)
        operationQueue.addOperation(filterOp)
        OperationQueue.main.addOperation(updateImageViewOp)
        
        let dateString = dateFormatter.string(from: photo.earthDate)
        detailLabel.text = "Taken by \(photo.camera.roverId) on \(dateString) (Sol \(photo.sol))"
        cameraLabel.text = photo.camera.fullName
    }
    
    
    // MARK: - Properties
    let operationQueue = OperationQueue()
    var photo: MarsPhotoReference? {
        didSet {
            updateViews()
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    
}
