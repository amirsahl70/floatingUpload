//
//  upload.swift
//  floatingUpload
//
//  Created by Amir on 8/7/2016.
//  Copyright © 2018 uni. All rights reserved.
//

import Foundation

class uploadClass{
    
    var progress :Float?
    var path : URL?
    
    init(progress : Float, path : URL) {
        self.progress = progress
        self.path = path
    }
    
}
