//
//  ImageInfo.swift
//  MemeMe1
//
//  Created by Ahmed on 13/11/2018.
//  Copyright © 2018 Ahmed. All rights reserved.
//

import Foundation
import UIKit

struct Meme
{
   var topText: String
   var  bottomText: String
  var originalImage: UIImage
  var memedImage: UIImage
    
}

class MemeManager{
    
    static let shared = MemeManager()
    
   var memes = [Meme]()
    
    private init(){}
    
    
    
}
