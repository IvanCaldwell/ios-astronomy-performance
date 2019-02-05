//
//  FilterImageOperation.swift
//  Astronomy
//
//  Created by Ivan Caldwell on 2/5/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class FilterImageOperation: Operation {
    
    private let fetchPhoto: FetchPhotoOperation
    
    private(set) var filteredImage: UIImage?
    
    init(fetchPhotoOperation: FetchPhotoOperation){
        fetchPhoto = fetchPhotoOperation
        super.init()
    }
    
    override func main() {
        if let data = fetchPhoto.imageData {
            filteredImage = UIImage(data: data)?.filtered()
        }
    }
}
