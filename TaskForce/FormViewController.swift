//
//  FormViewController.swift
//  TaskForce
//
//  Created by Jimmy Carney on 4/25/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import UIKit

class FormViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var ChargeAmount: UITextField!
    @IBOutlet weak var VenmoNote: UITextField!

    
   var imagePicker: UIImagePickerController!
    
    
    @IBAction func TakePic(_ sender: Any) {
       /* imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil) */
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        picture.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        ChargeAmount.keyboardType = .decimalPad
        VenmoNote.keyboardType = .asciiCapable
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
