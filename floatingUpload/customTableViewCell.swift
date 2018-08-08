//
//  customTableViewCell.swift
//  floatingUpload
//
//  Created by Amir on 8/6/2016.
//  Copyright © 2018 uni. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell {

   var obj = ViewController()
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var progrssBar: UIProgressView!
    @IBOutlet weak var progressLable: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    
    @IBAction func start(_ sender: Any) {
        print(obj.uploadprogressList.count)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
