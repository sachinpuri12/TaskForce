//
//  FormViewController.swift
//  TaskForce
//
//  Created by Jimmy Carney on 4/25/17.
//  Copyright © 2017 Sachin Puri. All rights reserved.
//

import UIKit
import Firebase

class FormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var ChargeAmount: UITextField!
    @IBOutlet weak var VenmoNote: UITextField!

    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var receiptView: UIView!
    @IBOutlet weak var chargeView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var picture: UIImageView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    var viewArray = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        
        ChargeAmount.keyboardType = .decimalPad
        VenmoNote.keyboardType = .asciiCapable
    }

    @IBAction func takePhoto(_ sender: Any) {

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            imagePicker.cameraCaptureMode = .photo

            self.present(imagePicker, animated: true, completion: nil)
         }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        picture.contentMode = .scaleAspectFit //3
        picture.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        viewArray = [noteView,  receiptView, chargeView]
        
        for view in viewArray{
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(colorLiteralRed: 0.88, green: 0.88, blue: 0.89, alpha: 1).cgColor
            view.layer.cornerRadius = 8
        }
        takePhotoButton.layer.cornerRadius = 8
        sendButton.layer.cornerRadius = 8

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendToVenmo(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
        ref.child("tasks/\(globalMyTaskKey)").updateChildValues(["status": "completed"])
        
        let alert = UIAlertController(title: "Venmo Request Sent!", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        let storage = FIRStorage.storage().reference().child("jimmy.jpg")
        
        
        if let upload_data = UIImagePNGRepresentation(picture.image!){
            print("HOW")
            storage.put(upload_data, metadata: nil, completion: { (metadata, error) in
                
            })
            storage.put(upload_data)
        }
        

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
