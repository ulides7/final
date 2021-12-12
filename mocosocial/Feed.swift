//
//  Feed.swift
//  mocosocial
//
//  Created by Ulises M on 12/12/21.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper
import FirebaseDatabase
import FirebaseStorage

class Feed: UIViewController {

    @IBOutlet weak var salir: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func postimage (_ sender: AnyObject) {
       
        
    }
    
    @IBAction func cerrarsesion (_ sender: AnyObject){
        try! Auth.auth().signOut()
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
