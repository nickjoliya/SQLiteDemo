

import UIKit
import SQLite3
import Foundation

class SetContactViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var dicContact = [list]()
    
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var viewBgGradiun: UIView!
    
    var name = ""
    var contact = ""
    var index: Int32? = nil
    var btnTitle = "Save"
    var isEdit = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.layer.borderWidth = 0.5
        btnSave.layer.cornerRadius = 5
        btnSave.layer.borderColor  = UIColor.white.cgColor
        
        btnSelectImage.layer.borderWidth = 0.5
        btnSelectImage.layer.cornerRadius = 5
        btnSelectImage.layer.borderColor  = UIColor.white.cgColor
        
        //set data if we get it from vc
        txtName.text = name
        txtContact.text = contact
        btnSave.setTitle(btnTitle, for: .normal)
        title = "Store Contact"
        
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
                        
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = viewBgGradiun.bounds
                    
            viewBgGradiun.layer.insertSublayer(gradientLayer, at:0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imgProfile.isHidden = true
    }
    
    func showAlert(msg: String) {
        
        let alertView:UIAlertController = UIAlertController(title:  "Alert", message: msg, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alertView.dismiss(animated: true, completion: nil)
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        if imgProfile.image != nil{
            if (!txtName.text!.isEmpty) && (!txtContact.text!.isEmpty) {
                if isEditing {
                    //edit in database
                    let db = DBManager()
                    if index != nil{
                        let myImage : UIImage = imgProfile.image ?? UIImage(systemName: "profile")!
                        let imageData:NSData = myImage.jpegData(compressionQuality: 0.1)!as NSData
                        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                        db.editIndex(id: index!, name: txtName.text ?? "noob Name", number: txtContact.text ?? "noob Contact", image: strBase64)
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }
                else if !isEditing{
                    //save in database
                    //                #warning("convert image")
                    let myImage : UIImage = imgProfile.image ?? UIImage(systemName: "profile")!
                    let imageData:NSData = myImage.jpegData(compressionQuality: 0.1)!as NSData
                    let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                    let db = DBManager()
                    db.insert(name: (txtName.text ?? "noob"), number: (txtContact.text ?? "12345"), image: strBase64)
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }else{
                print("Empty Element")
            }
        }else{
            showAlert(msg: "Please Select Image")
            
        }
        
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imgProfile.image = image
        
        
        
    }
    
    
    
    
    @IBAction func btnSelectProfile(_ sender: UIButton) {
        
        imgProfile.isHidden = false
        openGallery()
    }
    
    
    @IBAction func btnNameChanged(_ sender: UITextField) {
        
    }
    
    
    //    func isValidEmail(email:String?) -> Bool {
    //
    //        guard email != nil else { return false }
    //
    //        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    //
    //        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
    //        return pred.evaluate(with: email)
    //    }
    
    //not working
}

