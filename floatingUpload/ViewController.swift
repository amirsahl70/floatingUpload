//
//  ViewController.swift
//  floatingUpload
//
//  Created by Amir on 8/4/2016.
//  Copyright © 2018 uni. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Floaty
import ImagePicker
import Photos

class ViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, ImagePickerDelegate {

    var imagePath : URL?
    var sessionManager = SessionManager()
    let serverURL = URL(string: "https://192.168.17.253:443/app_dev.php/ios/test/upload")
    var libraryPathList :[URL] = []
    var uploadprogressList : [uploadClass] = []
    var prgressReport : Float?
    
    let dispatch = DispatchGroup()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        floatyButton()
    }
    
    func floatyButton(){
        let floaty = Floaty()
        floaty.addItem("Photo / Video", icon: UIImage(named:"share.png"),handler:{_ in self.imagePicker()})
        self.view.addSubview(floaty)
    }
    
// IMAGE PICKER
    func imagePicker(){
        
        var config = Configuration()
        config.doneButtonTitle = "Done"
        config.allowVideoSelection = true
        
        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.delegate = self as ImagePickerDelegate
        
        present(imagePicker,animated: true,completion: nil)
        
    }

    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    }
    
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        let assets = imagePicker.stack.assets
        let photoOption = PHContentEditingInputRequestOptions()
        let videoOption = PHVideoRequestOptions()
        
        
        
        for asset in assets{
            dispatch.enter()
            if asset.mediaType ==  .image {
                
                asset.requestContentEditingInput(with: photoOption, completionHandler: { contentEditingInput, info in
                   let imagePath = contentEditingInput?.fullSizeImageURL
                    //self.libraryPathList.append(imagePath!)
                    self.uploadImage(libraryPath : imagePath!)
                       self.dispatch.leave()
                })
                
            }else if asset.mediaType == .video{
                
                videoOption.version = .original
                PHImageManager.default().requestAVAsset(forVideo: asset, options: videoOption, resultHandler: { (asset, aucioMix, info) in
                    if let urlAsset = asset as? AVURLAsset {
                        let videPath = urlAsset.url
                        //self.libraryPathList.append(videPath)
                        self.uploadImage(libraryPath : videPath)
                        self.dispatch.leave()
                    }else {
                        self.uploadImage(libraryPath : nil)
                    }
                })
            }
            
            
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        dispatch.notify(queue: .main) { DispatchQueue.main.async {self.tableView.reloadData()}}
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

// UPLOAD PART
    func uploadResult(result : SessionManager.MultipartFormDataEncodingResult, path : URL){
        
        let uploadprogress = uploadClass(progress : 0, path : path)
        self.uploadprogressList.append(uploadprogress)
        
        switch result {
        case .success(let upload,_,_):
            upload.responseJSON { res in
                print("response --> \(res.result.value as Any)")

            }
            upload.uploadProgress { progress in
                print("Upload Progress : \(progress.fractionCompleted)")
                self.prgressReport = Float(progress.fractionCompleted)
                // self.progressBarView.progress = Float(progress.fractionCompleted)
                // let progressPercent = Int(progress.fractionCompleted * 100)
                // self.percentLabel.text = "\(progressPercent)%"
            }
            
            
        case .failure(let error): print("error is -->> \(error)")
            
        }
        
    }
    
    
    func uploadImage(libraryPath : URL?){
       guard let serverPath = serverURL else { return }
        HttpHandler.upload(serverPath: serverPath, libraryPath: libraryPath, sessionManager: sessionManager, completionHandler: uploadResult )
       }
    
    
    
// TableView DElegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.uploadprogressList.count //self.libraryPathList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return tableView.frame.size.height
        return 122
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellView = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! customTableViewCell
        
        let idx: Int = indexPath.row
        
        //cellView.progrssBar.progress = uploadprogressList[idx].progress!
        displayImage(idx, photoCell: cellView)
        if idx % 2 == 0 {
            cellView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
        
        return cellView
    }
    func displayImage(_ row: Int, photoCell: customTableViewCell) {
        
        let url = uploadprogressList[row].path
        let data = try? Data(contentsOf : url!)
        if let image = UIImage(data: data!){
            DispatchQueue.main.async {
                photoCell.photoImageView.image = image
            }
        }
    }
    
    
}

