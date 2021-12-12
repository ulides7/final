//
//  UsuarioVC.swift
//  mocosocial
//
//  Created by Ulises M on 09/12/21.
//


import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class UsuarioVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
@IBOutlet weak var userImagePicker: UIImageView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var completeSignInBtn: UIButton!
    
    var userUid: String!
    
    var emailField: String!
    
    var passwordField: String!
    
    var imagePicker : UIImagePickerController!
    
    var imageSelected = false
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
    }
    
    func keychain(){
        
        KeychainWrapper.standard.set(userUid, forKey: "uid")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            
            userImagePicker.image = image
            
            imageSelected = true
            
        } else {
            
            print("image wasnt selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setUpUser(img: String){
        
        let userData = [
            "username": username!,
            "userImg": img
        ]
        
        keychain()
        
        let setLocation = Database.database().reference().child("users").child(userUid)
        
        setLocation.setValue(userData)
    }
   
    
    func uploadImg() {
        
        if usernameField.text == nil {
            
            print("must have username")
            
            completeSignInBtn.isEnabled = false
            
        } else {
            
            username = usernameField.text
            
            completeSignInBtn.isEnabled = true
        }
        guard let img = userImagePicker.image, imageSelected == true else {
            
            print("image must be selected")
            
            return
        }
  
       
        
  
        
        
        func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let storageRef = Storage.storage().reference().child("user/\(uid)")

            guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }

            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
           

            storageRef.putData(imageData, metadata: metaData) { metaData, error in
                if error == nil, metaData != nil {

                    storageRef.downloadURL { url, error in
                        completion(url)
                        self.setUpUser(img: url!.absoluteString)
                        
                        // success!
                    }
                    } else {
                        // failed
                        completion(nil)
                       
                    }
                }
            }

        
        
//        if let imagData = img.jpegData (compressionQuality: 0.2) {
//            let imgUid = NSUUID().uuidString
//            let metadata = StorageMetadata()
//
//            metadata.contentType = "img/jpeg"
//
//          let storageRef =  Storage.storage().reference().child(imgUid).putData(imagData,metadata: metadata){ (metadata,error) in
//                if error != nil {
//                    print("La imagen no se cargo")
//                } else {
//                    print("cargada")
//
//
//                    let downloadURl =   metadata?.downloadURL()?.absoluteString
//
//
//                   if let url = downloadURl {
//                        self.setUpuser(img: url)
//                   }
//
//                    }
//        }
//
//    }
    }
    
    
    @IBAction func completeAccount(_ sender: Any){
        
        Auth.auth().createUser(withEmail: emailField, password: passwordField, completion: { (user,error) in
            
            if error != nil {
                
                print("cant create user \(error)")
                
            } else {
                
                if let user = user {
                    
                    self.userUid = user.user.uid
                }
            }
            
            self.uploadImg()
        })
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func seletedImagePicker(_ sender: Any){
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: AnyObject){
        
        dismiss(animated: true, completion: nil)
    }
}

    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


