//
//  CameraViewController.swift
//  Assignment3
//
//  Created by admin on 2020/11/13.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseStorage
//choose an image from image library and upload to the firebase storage and retrive url from firebase
class CameraViewController: UIViewController, NetworkListener, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    
    private let storage = Storage.storage().reference()
    
    //implement the listener methods
    func onRequest() {
        
    }
    
    func onResponse(response: AnyObject?, error: Error?) {
        let res = response as! ImageAnalysisResponse
        guard let category: String = res.category?.name else{
            return
        }
        guard let probability: Double = res.category?.probability else{
            return
        }
        urlLabel.text = "category is : \(category) . The possibility is : \(String(probability))"
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func uploadBtn(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true)
    }
    
    //called when user choose an image from the library
    //用户选择了照片后运行该方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        cameraImage.image = image
        
        guard let imageData = image.pngData() else{
            return
        }
        //upload image data
        //get download url
        //save url to userDefaults
        
        // Create file metadata including the content type
        
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        storage.child("file.png").putData(imageData, metadata: metadata, completion: {_, error in
            guard error == nil else{
                print("Failed to upload")
                return
            }
            self.storage.child("file.png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else{
                    return
                }
                let urlString = url.absoluteString
                
                //modify the url, remove token
                let modifyUrl =  urlString.components(separatedBy: "&")[0]
                
                //print("downloading the url : \(modifyUrl)")
                //self.urlLabel.text = modifyUrl
                UserDefaults.standard.set(modifyUrl, forKey: "url")
                
                let control = NetworkController(listener: self)
                control.imageClassification(url: modifyUrl)
                
            })
            
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
