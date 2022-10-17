

import UIKit
import SQLite3
import Foundation

var dicContact = [list]()

class ViewController: UIViewController {
    
    @IBOutlet weak var btnAddContact: UIBarButtonItem!
    @IBOutlet weak var tblContact: UITableView!
    var db = DBManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblContact.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        self.title = "Contacts"
        
//        db.deleteDatabase()
//        db.insert(name: "Hiren", number: "999999")
        
        
        dicContact = db.readData()
        
//        view.backgroundColor = .darkGray
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
                        
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
                    
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // must reload table array after doing anything in array element
        dicContact = db.readData()
        tblContact.reloadData()
        print("\(dicContact)............data")
    }
    
  
    
  


    
    @IBAction func btnActionAddContact(_ sender: UIBarButtonItem) {
        
        let vc = storyboard?.instantiateViewController(identifier: "SetContactViewController")as! SetContactViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dicContact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblContact.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)as! ItemCell
        cell.lblName.text = dicContact[indexPath.row].name
        cell.lblNumber.text = dicContact[indexPath.row].number
        let strBase64 = dicContact[indexPath.row].image
        print(strBase64)
//        if let dataDecoded:NSData = NSData(base64Encoded: strBase64, options: NSData.Base64DecodingOptions(rawValue: 0)){
//            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
//            cell.imgProfile.image = decodedimage
//        }
        if let imagerData = Data.init(base64Encoded: strBase64, options: Data.Base64DecodingOptions.ignoreUnknownCharacters){
            cell.imgProfile.image = UIImage(data: imagerData)
        }
        
        cell.layer.cornerRadius = 10
        return cell
    }
    
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print("button tapped...")
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tblContact.frame.height/8
    }
    
    
    // edit swipe action 
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
//            print("delete contact from Database")
//            db = DBManager()
//            db.deleteIndex(id: dicContact[indexPath.row].id)
//            dicContact = db.readData()
//            tblContact.reloadData()

            //delete popup to confirm
            let DeleteAlert = UIAlertController(title: "Delete", message: "Are you Sure To Delete Contact.", preferredStyle: UIAlertController.Style.alert)

                DeleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Deleting Element")
                print("delete contact from Database")
                self.db = DBManager()
                self.db.deleteIndex(id: dicContact[indexPath.row].id)
                dicContact = self.db.readData()
                self.tblContact.reloadData()
            }))

            DeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
            }))

            present(DeleteAlert, animated: true, completion: nil)
        }
       
    }
    
    //swipe right to edit
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editbtn = UIContextualAction(style: .normal, title: "Edit"){_,_,_ in
            print("edit tapped ... \(dicContact[indexPath.row].id)")
            
            let vc = self.storyboard?.instantiateViewController(identifier: "SetContactViewController")as! SetContactViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            //send data to vc
            
            vc.name = dicContact[indexPath.row].name
            vc.contact = dicContact[indexPath.row].number
            vc.btnTitle = "Edit"
            vc.index = dicContact[indexPath.row].id
            vc.isEditing = true
            }
        
        editbtn.backgroundColor = #colorLiteral(red: 0.1992724114, green: 0.2992762219, blue: 0.3381979695, alpha: 1)
        editbtn.title = "Edit Contact"
        let edit = UISwipeActionsConfiguration(actions: [editbtn])
        
        return edit
    }
    
}


