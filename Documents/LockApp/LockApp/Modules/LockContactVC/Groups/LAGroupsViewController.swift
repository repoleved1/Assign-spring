//
//  LAGroupsViewController.swift
//  LockApp
//
//  Created by Feitan on 8/4/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import RealmSwift
import Contacts
import ContactsUI
import MessageUI

class LAGroupsViewController: BaseVC, MFMessageComposeViewControllerDelegate, CNContactViewControllerDelegate {
    
    @IBOutlet weak var tbvGroup: UITableView!
    
    let ramdomColorView = RandomColor()
    var listData:Results<Group>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbvGroup.delegate = self
        tbvGroup.dataSource = self
        
        tbvGroup.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        tbvGroup.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listData = DatabaseService.sharedInstance.getGroup()
        self.tbvGroup.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func btnDeleteClick(sender:UIButton) -> Void {
        let alertView = UIAlertController(title: "Alert", message: "Do you want delete this group", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "YES", style: .default, handler: {
            action in
            DatabaseService.sharedInstance.delete(self.listData[sender.tag])
            self.tbvGroup.reloadData()
        })
        let actionNO = UIAlertAction(title: "NO", style: .default, handler: {
            action in
        })
        alertView.addAction(actionYes)
        alertView.addAction(actionNO)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    @objc func sendSMS(sender:UIButton) -> Void {
        if (MFMessageComposeViewController.canSendText()) {
            let arrContact = listData[sender.tag].listContact
            var phone = [""]
            for contact in arrContact{
                phone.append(contact.phoneNumber)
            }
            
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = phone
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LAGroupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return (listData != nil) ? listData.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: 40))
        view.backgroundColor = .white
        let lb = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.size.width , height:40))
        lb.text = listData[section].groupname
        lb.font = UIFont.init(name: "Quicksand-Bold", size: 17)
        lb.textColor = .black
        view.addSubview(lb)
        
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 50, y: 0, width: 40, height: 41))
        btn.setImage(UIImage(named: "ic_Deleted"), for: .normal)
        btn.tag = section
        btn.addTarget(self, action: #selector(btnDeleteClick(sender:)), for: .touchUpInside)
        view.addSubview(btn)
        
        let btnMsg = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 100, y: 5, width: 36, height: 35))
        btnMsg.setImage(UIImage(named: "ic_Message"), for: .normal)
        btnMsg.tag = section
        btnMsg.addTarget(self, action: #selector(sendSMS(sender:)), for: .touchUpInside)
        view.addSubview(btnMsg)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listData[section].listContact.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell

        let object = listData[indexPath.section].listContact[indexPath.row]
        
        let toFetch = [CNContactViewController.descriptorForRequiredKeys()]
        let contactStore = CNContactStore()
        
        do {
            let cnContact = try contactStore.unifiedContact(withIdentifier: listData[indexPath.section].listContact[indexPath.row].indentifier, keysToFetch: toFetch)
            cell.nameNumber.text = cnContact.givenName+" "+cnContact.familyName
            
        } catch {
            print("error")
        }
        
        var text = ""
        let givenName: Character! = object.giveName.first
        let familyName: Character! = object.familyName.first
        
        print("givenName", givenName)
        if givenName != nil  {
            text.append(givenName)
        } else   {
            text.append(".")
        }
        if familyName != nil {
            text.append(familyName)
        }
        
        cell.lbNamePeople.text = text.uppercased()
        cell.viewNamePeople.backgroundColor = ramdomColorView.randomColor()
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
