//
//  AddContactViewController.swift
//  LockApp
//
//  Created by Feitan on 8/17/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class AddContactViewController: BaseVC {
    
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var btSelect: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewDeleteAll: UIView!
    
    let randomColorView = RandomColor()
    var searchActive : Bool = false
    var filterName = [ItemFavorites]()
    let delete = GetContact()
    var checkShowDeleteAll =  true
    var dataContact = [ItemFavorites]()
    
    var arrSelect = [ItemFavorites]()
    var titleStr = ""
    
    var index = 0
    var pathFile: URL?
    var save = SaveBackup()
    
    init(_ data: [ItemFavorites], titleStr: String) {
        super.init(nibName: "AddContactViewController", bundle: nil)
        self.dataContact = data
        self.titleStr = titleStr
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navi.title = ""
        navi.handleBack = {
            self.clickBack()
        }
        
        tableView.register(UINib(nibName: "AddContactToGroupTableViewCell", bundle: nil), forCellReuseIdentifier: "AddContactToGroupTableViewCell")
        tableView.delegate = self
        tableView.dataSource =  self
        btSelect.addTarget(self, action: #selector(choiceAll), for: .touchUpInside)
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = 50
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    @objc func choiceAll() {
        if checkShowDeleteAll == true {
            ShareData.sharedInstance.nameImageTick = "ic_selected"
            selectAllRows()
        } else {
            ShareData.sharedInstance.nameImageTick = "ic_select"
            tableView.reloadData()
        }
        checkShowDeleteAll = !checkShowDeleteAll
    }
    
    @IBAction func backUpData(_ sender: Any) {
        if Reachability.isConnectedToNetwork() == true {
            if PaymentManager.shared.isPurchaseContact(){
                _ = UIAlertController.present(style: .alert, title: "app_name".localized, message: "Do you want to synchronize your contacts data?".localized, attributedActionTitles: [("txt_ok".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
                    if action.title == "txt_ok".localized {
                        self.shareMail(self.creatStringBackup(1))
                    }
                })
            }else{
                
            }
        } else {
            let alertView = UIAlertController(title: "Error", message: "Please, connect internet", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: nil)
            alertView.addAction(actionYes)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    @IBAction func btDeleteAll(_ sender: Any) {
        if arrSelect.count == 0 {
            Common.showAlert("No item in selected")
        }else{
            _ = UIAlertController.present(style: .alert, title: "app_name".localized, message: "txt_delete_selector".localized, attributedActionTitles: [("txt_ok".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
                if action.title == "txt_ok".localized {
                    self.arrSelect.forEach({ (items) in
                        
                        self.delete.deleteContact(items)
                        
                        let index1 = ShareData.sharedInstance.arrContact.firstIndex(where: { (objs) -> Bool in
                            return objs.familyName == items.familyName && objs.phone == items.phone && objs.giveName == items.giveName
                        })
                        
                        if index1 != nil {
                            ShareData.sharedInstance.arrContact.remove(at: index1!)
                        }
                        
                        let index2 = self.dataContact.firstIndex(where: { (objs) -> Bool in
                            return objs.familyName == items.familyName && objs.phone == items.phone && objs.giveName == items.giveName
                        })
                        
                        if index2 != nil {
                            self.dataContact.remove(at: index2!)
                        }
                        
                    })
                    self.tableView.reloadData()
                }
            })
        }
    }
    
}

extension AddContactViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filterName.count
        }
        return dataContact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddContactToGroupTableViewCell") as! AddContactToGroupTableViewCell
        var arrContact = [ItemFavorites]()
        if searchActive {
            arrContact = filterName
        } else {
            arrContact = dataContact
        }
        
        cell.nameNumber.text = arrContact[indexPath.row].giveName + " " + arrContact[indexPath.row].familyName
        
        var text = ""
        let givenName: Character! =  arrContact[indexPath.row].giveName.first
        let familyName: Character! = arrContact[indexPath.row].familyName.first
        
        if givenName != nil  {
            text.append(givenName)
        }
        if familyName != nil {
            text.append(familyName)
        }
        
        cell.lbNamePeople.text = text.uppercased()
        cell.viewNamePeople.backgroundColor = randomColorView.randomColor()
        cell.selectionStyle = .none
        cell.viewNamePeople.layer.cornerRadius = cell.viewNamePeople.frame.size.height / 2
        cell.viewNamePeople.clipsToBounds = true
        cell.viewNamePeople.layer.masksToBounds = true
        cell.config()
        
        //handle
        
        cell.handleSelect = {
            print("select \(indexPath.row)")
            self.arrSelect.append(self.dataContact[indexPath.row])
        }
        
        cell.handleUnselect = {
            print("unselect \(indexPath.row)")
            if self.arrSelect.count > 0 {
                let index = self.arrSelect.firstIndex(where: { (objs) -> Bool in
                    return objs.familyName == self.dataContact[indexPath.row].familyName && objs.phone == self.dataContact[indexPath.row].phone && objs.giveName == self.dataContact[indexPath.row].giveName
                })
                if index != nil {
                    self.arrSelect.remove(at: index!)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            delete.deleteContact(dataContact[indexPath.row])
            ShareData.sharedInstance.arrContact.remove(at: indexPath.row)
            dataContact.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
            tableView.endUpdates()
        }
    }
    
    func selectAllRows() {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                tableView.selectRow(at: IndexPath(row: row, section: section), animated: false, scrollPosition: .none)
            }
        }
    }
    
    //Backup
    
    func shareMail(_ stringMail: String)
    {
        let mailClass : AnyClass? = NSClassFromString("MFMailComposeViewController")
        if mailClass != nil
        {
            if MFMailComposeViewController.canSendMail()
            {
                displayComposerSheet(stringMail)
            }
            else
            {
                launchMailAppOnDevice()
            }
        }
        else
        {
            launchMailAppOnDevice()
        }
    }
    
    func launchMailAppOnDevice()
    {
        
        let alertView = UIAlertController(title: "", message: "Please, set up mail. Setting -> Accounts & Passwords -> Add Acount.", preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        exit(1)
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        })
        alertView.addAction(actionYes)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func displayComposerSheet(_ stringMail: String)
    {
        let picker : MFMailComposeViewController = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.delegate = self
        picker.setSubject("Test")
        picker.setMessageBody("Mail Sharing !", isHTML: true)
        
        let data = writeFile(text: stringMail, to: "mail_backup").data(using: .utf8)
        picker.addAttachmentData(data!, mimeType: "txt", fileName: "mail_backup.txt")
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func writeFile(text: String, to fileNamed: String, folder: String = "SavedFiles") -> String {
        let dir = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        var inString = ""
        // If the directory was found, we write a file to it and read it back
        if let fileURL = dir?.appendingPathComponent(fileNamed).appendingPathExtension("txt") {
            pathFile = fileURL
            // Write to the file named Test
            do {
                try text.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
            
            // Then reading it back from the file
            
            do {
                inString = try String(contentsOf: fileURL)
            } catch {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            }
            print("Read from the file: \(inString)")
        }
        
        return inString
    }
    
    func deleteFile() {
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: pathFile!)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func creatStringBackup(_ indexRow: Int) -> String {
        var contentBackup = ""
        if index == 0 {
            for data in ShareData.sharedInstance.arrContact {
                contentBackup = contentBackup + (data.giveName + " " + data.familyName + " " + "Phone Number:: " + data.phone + "\n")
            }
            ShareData.sharedInstance.contentFileUpload = contentBackup
        } else {
            let getAllBackupSave = DatabaseService.sharedInstance.getAllBackup()
            let datas = getAllBackupSave[indexRow - 1].contactBackup
            for data in datas {
                contentBackup = contentBackup + ( data.giveName1 + " " + data.familyName1 + " " + "Phone Number:: " + data.phone1 + "\n")
                
            }
            ShareData.sharedInstance.contentFileUpload = contentBackup
        }
        
        return contentBackup
    }
    
}

extension AddContactViewController: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            print("Mail cancelled")
            deleteFile()
            break
        case .saved:
            print("Mail saved")
            break
        case .sent:
            print("Mail sent")
            deleteFile()
            if index == 0 {
                save.backupSaveDataBaseOne()
            }else {
                save.backupSaveDataBaseTwo(index - 1)
            }
            break
        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

class SaveBackup {
    
    func backupSaveDataBaseOne() {
        let backupSave = BackupItem()
        
        for data in ShareData.sharedInstance.arrContact {
            let shareContact = BackupDatabase()
            shareContact.familyName1 = data.familyName
            shareContact.giveName1 = data.giveName
            shareContact.phone1 = data.phone
            backupSave.contactBackup.append(shareContact)
        }
        
        backupSave.dateSave = Date()
        
        DatabaseService.sharedInstance.add(backupSave)
    }
    
    func backupSaveDataBaseTwo(_ index: Int) {
        let backupSave = BackupItem()
        let abc = DatabaseService.sharedInstance.getAllBackup()
        
        for data in abc[index].contactBackup {
            let shareContact = BackupDatabase()
            shareContact.familyName1 = data.familyName1
            shareContact.giveName1 = data.giveName1
            shareContact.phone1 = data.phone1
            backupSave.contactBackup.append(shareContact)
        }
        
        backupSave.dateSave = Date()
        
        DatabaseService.sharedInstance.add(backupSave)
    }
}

import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}
