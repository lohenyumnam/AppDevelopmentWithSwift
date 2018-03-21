//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Lohen Yumnam on 17/03/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    let photoInfoController = PhotoInfoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        
        photoInfoController.fetchPhotoInfo { (photoInfo) in
            if let photoInfo = photoInfo {
                self.updateUI(with: photoInfo)
            }
        }
        
    }

    func updateUI(with photoInfo: PhotoInfo){
        let task = URLSession.shared.dataTask(with: photoInfo.url) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data){

                // Sending this block of code to main Queue
                    DispatchQueue.main.async {
                        self.title = photoInfo.title
                        self.descriptionLabel.text = photoInfo.description
                        self.imageView.image = image

                        if let copyright = photoInfo.copyright{
                            self.copyrightLabel.text = "Compyright: \(copyright)"
                        } else {
                            self.copyrightLabel.isHidden = true
                        }
                }
            }
        }

        task.resume()
    }

   
}

