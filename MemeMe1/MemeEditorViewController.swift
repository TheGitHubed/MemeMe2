//
//  ViewController.swift
//  MemeMe1
//
//  Created by Ahmed on 07/11/2018.
//  Copyright © 2018 Ahmed. All rights reserved.
//

import UIKit

class MemeEditorViewController :  UIViewController , UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(tf: topTextField, text: "TOP")
        setupTextField(tf: bottomTextField, text: "BOTTOM")
           shareButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
       
 
    }
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    func setupTextField(tf: UITextField, text: String) {
        tf.defaultTextAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -4 ]
        
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
        tf.delegate = self
    }
    
    //Mark : Actions
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
       chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        chooseImageFromCameraOrPhoto(source: .camera)
    }
    
    @IBAction func Share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController  = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (type,completed,items,error) in
            if completed {
                self.save()
            }
        }
         present(activityViewController, animated: true, completion: nil)

    }
    
    @IBAction func Cancel(_ sender: Any) {
         imageView.image = nil
        topTextField.text="TOP"
        bottomTextField.text="BOTTOM"
        shareButton.isEnabled = false
        dismiss(animated: true, completion: nil)
        
    }
    
    //Mark : Image Picking
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            self.cancelButton.isEnabled = true
            self.shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        if imageView.image == nil {
        shareButton.isEnabled = false
        }
    }
   
    //Mark: TextFields Operations
    func textFieldDidBeginEditing(_ textField: UITextField)     {
        
     textField.text = (textField.text == "TOP" || textField.text == "BOTTOM") ? "" : textField.text
        if textField.tag==1 {
              subscribeToKeyboardNotifications()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.text =  textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  ? ( textField.tag == 0 ? "TOP" : "BOTTOM") : textField.text
        if textField.tag==1 {
             unsubscribeFromKeyboardNotifications()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   //Keyboard Move
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
       view.frame.origin.y -= getKeyboardHeight(notification)
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
        
    }
   
    
    //Mark: Meme object generation
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.topToolbar.isHidden=true
        self.bottomToolbar.isHidden=true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        self.topToolbar.isHidden=false
        self.bottomToolbar.isHidden=false
        
        return memedImage
    }
  
    func save() {
       let memedImage =  generateMemedImage()
      let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
              
        MemeManager.shared.memes.append(meme)
          dismiss(animated: true, completion: nil)
        
        
    }
    
}


