//
//  customTableViewCell.swift
//  floatingUpload
//
//  Created by Amir on 8/6/2016.
//  Copyright © 2018 uni. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell {

   
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var progrssBar: UIProgressView!
    @IBOutlet weak var progressLable: UILabel!
//
//    var timer : Timer!
//    var uploadBar :  uploadClass? {
//        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { time in
//            print("Timer\(time)")
//            progrssBar.progress = pro
//
//        })
    //}
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
