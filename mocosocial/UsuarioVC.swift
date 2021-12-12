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
    
    @IBOutlet weak var userimagen: UIImageView!
    @IBOutlet weak var nombredeusuariolbl: UITextField!
    @IBOutlet weak var completarregistro: UIButton!
    
    
    var userUid: String!
    var emaillbl: String!
    var contraseñalbl: String!
    var imagenelegida: UIImagePickerController!
    var imagenseleccionada = false
    var username: String!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

          imagenelegida = UIImagePickerController()
        imagenelegida.delegate = self
        imagenelegida.allowsEditing = true
        
    }
    func setUpuser(img: String){
        let userData = ["usuario": username, "imagen de usuario" : img]
        keychain()
        let setLocation = Database.database().reference().child("users").child(userUid)
        setLocation.setValue(userData)
     
        
    }
   
    func keychain(){
        KeychainWrapper.standard.set(userUid, forKey: "uid")
    }
    
   
    
    func UploadImage() {
        if nombredeusuariolbl == nil {
            print("Necesitas un usuario")
            completarregistro.isEnabled = false
        } else {
            username = nombredeusuariolbl.text
            completarregistro.isEnabled = true
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagen = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userimagen.image = imagen
            imagenseleccionada = true
        } else {
            print("Imagen seleccioanda")
        }
        imagenelegida.dismiss(animated: true, completion: nil)
        
    }
    
        
       
        
  
        
    guard let img = userimagen.image , imagenseleccionada == true else {
             print("la imagen tiene que seleccionarse")
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
                        self.setUpuser(img: url!.absoluteString)
                        
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
        Auth.auth().createUser(withEmail: emaillbl, password: contraseñalbl, completion: { (user , error)  in
                                   if error != nil {
                                   //    print("No se pudo crear el usuario")
        } else {
            if let user = user {
                self.userUid = user.user.uid
            }
        }
            self.UploadImage()
        })
        dismiss(animated: true , completion: nil)
    }
        
    @IBAction func selectedImagePicker(_ sender: Any)
    {
        present(imagenelegida, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: AnyObject ) {
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


