//
//  ViewController.swift
//  mocosocial
//
//  Created by Ulises M on 07/12/21.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class ViewController: UIViewController {

    var userUid: String!
    @IBOutlet weak var emaillbl: UITextField!
    @IBOutlet weak var contraseñalbl: UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func crearusuarioVC(){
        performSegue(withIdentifier: "Registrate", sender: nil)
    }

    func homeVC(){
        performSegue(withIdentifier: "home", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            homeVC()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Registrate"{
            if let destination = segue.destination as? UsuarioVC {
            if userUid != nil {
                destination.userUid = userUid
            }
                if emaillbl.text != nil {
                    destination.emailField = emaillbl.text
                }
                if contraseñalbl.text != nil {
                    destination.passwordField = contraseñalbl.text
                }
        }
        }
        
    }
    
    
    @IBAction func enviar(_ sender: Any) {
        if let email = emaillbl.text, let contraseña = contraseñalbl.text {
            
            Auth.auth().signIn(withEmail: email, password: contraseña, completion: {
                (user , error) in
                if error == nil {
                    if let user = user {
                        self.userUid = user.user.uid
                        self.homeVC()
                    }
                } else {
                    self.crearusuarioVC()
                }
            });
        }
            
        
        
    }
    
    

}

