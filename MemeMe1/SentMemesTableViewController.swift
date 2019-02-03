//
//  SentMemesTableViewController.swift
//  MemeMe1
//
//  Created by Ahmed on 21/11/2018.
//  Copyright © 2018 Ahmed. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    var memes  : [Meme]!

    override func viewWillAppear(_ animated: Bool) {
        memes = MemeManager.shared.memes 
     tableView!.reloadData()
        
    }
    
    @IBAction func AddImage(_ sender: UIBarButtonItem) {
        
        let activityViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(activityViewController, animated: true, completion: nil)
        
    }
    
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath)
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text =   "\(meme.topText).... \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SentMemeDetailViewController") as! SentMemeDetailViewController
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}
