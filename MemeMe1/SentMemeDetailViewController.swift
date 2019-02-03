//
//  SentMemeDetailViewController.swift
//  MemeMe1
//
//  Created by Ahmed on 21/11/2018.
//  Copyright © 2018 Ahmed. All rights reserved.
//

import UIKit

class SentMemeDetailViewController: UIViewController {

    @IBOutlet weak var MemeImage: UIImageView!
     var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        MemeImage.image = meme.memedImage
    }

    

}
