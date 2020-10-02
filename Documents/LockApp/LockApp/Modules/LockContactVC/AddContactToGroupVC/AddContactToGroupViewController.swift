//
//  AddContactToGroupViewController.swift
//  LockApp
//
//  Created by Feitan on 8/21/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import CarbonKit
import Contacts
import ContactsUI
import AddressBook
import SwiftyContextMenu
import RealmSwift

class AddContactToGroupViewController: BaseVC {
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewContact: UIView!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var tbvContent: UITableView!
    @IBOutlet weak var tfNameGroup: UITextField!
    
    let ramdomColorView = RandomColor()
    var listData:[ItemFavorites]!
    var listSearch:[ItemFavorites]?
    var listSelected = NSMutableArray()
    var listContact = List<GroupItem>()
    var isSearch = false
    var groupName = ""
    var checkShowDeleteAll =  true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupToolbar()
        
        self.tfNameGroup.becomeFirstResponder()
        self.listData = ShareData.sharedInstance.arrContact

        tbvContent.delegate = self
        tbvContent.dataSource = self
        tbvContent.register(UINib(nibName: "AddContactToGroupTableViewCell", bundle: nil), forCellReuseIdentifier: "AddContactToGroupTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func btnDone() -> Void {

        if self.listContact.count > 0{
            let group = Group()
            group.groupname = groupName
            group.listContact = self.listContact
            DatabaseService.sharedInstance.add(group)

            self.navigationController?.popViewController(animated: true)
        }else{
            let alertView = UIAlertController(title: "Alert", message: "Please select contact!", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "OK", style: .default, handler: {
                action in
            })
            alertView.addAction(actionYes)
            self.present(alertView, animated: true, completion: nil)
        }
        
    }
    
    func setupUI() {
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = 50
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    func setupToolbar(){
        //Create a toolbar
        let bar = UIToolbar()
        //Create a done button with an action to trigger our function to dismiss the keyboard
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        //Create a felxible space item so that we can add it around in toolbar to position our done button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //Add the created button items in the toobar
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        //Add the toolbar to our textfield
        tfNameGroup.inputAccessoryView = bar
        
    }
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func createGroup(_ sender: Any) {
        nameGroup()
        btnDone()
    }
    
    @IBAction func choiceAll(_ sender: Any) {
        if checkShowDeleteAll == true {
            ShareData.sharedInstance.nameImageTick = "ic_selected"
            selectAllRows()
        } else {
            ShareData.sharedInstance.nameImageTick = "ic_select"
            tbvContent.reloadData()
        }
        checkShowDeleteAll = !checkShowDeleteAll
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nameGroup() -> Void {
        if (self.tfNameGroup.text?.count)! > 0 {
            self.groupName = self.tfNameGroup.text!
        }else{
            let alertView = UIAlertController(title: "Alert", message: "Please enter group name!", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "OK", style: .default, handler: {
                action in
            })
            alertView.addAction(actionYes)
            self.present(alertView, animated: true, completion: nil)
        }
    }
}

extension AddContactToGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch == true {
            return self.listSearch!.count
        }
        return self.listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddContactToGroupTableViewCell") as! AddContactToGroupTableViewCell
        var object = self.listData[indexPath.row]
        if isSearch == true {
            object = self.listSearch![indexPath.row]
        }
        
        var text = ""
        let givenName: Character! =  object.giveName.first
        let familyName: Character! = object.familyName.first
        
        cell.nameNumber.text = object.giveName + " " + object.familyName
        
        if givenName != nil {
            text.append(givenName)
        }
        if familyName != nil {
            text.append(familyName)
        }
        
        cell.lbNamePeople.text = text.uppercased()
        
        cell.viewNamePeople.backgroundColor = ramdomColorView.randomColor()
        
        
        let imageCheck: UIImageView = {
            let imageCheck = UIImageView()
            imageCheck.frame = CGRect(x: 0, y: 0 , width: cell.viewImageSelect.frame.width, height: cell.viewImageSelect.frame.height)
            imageCheck.image = UIImage(named: ShareData.sharedInstance.nameImageTick)
            return imageCheck
        }()
        
        if listSelected.contains(object) {
            imageCheck.image = UIImage(named: "ic_selected")
        }else{
            imageCheck.image = UIImage(named: "ic_select")
        }
        
        cell.viewNamePeople.layer.cornerRadius = cell.viewNamePeople.frame.size.height / 2
        cell.viewNamePeople.clipsToBounds = true
        cell.viewNamePeople.layer.masksToBounds = true
        
        cell.viewImageSelect.addSubview(imageCheck)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var object = self.listData[indexPath.row]
        if isSearch == true {
            object = self.listSearch![indexPath.row]
        }
        if listSelected.contains(object) {
            listSelected.remove(object)
        }else{
            listSelected.add(object)
        }

        let groupItem  = GroupItem()
        groupItem.giveName = object.giveName
        groupItem.familyName = object.familyName
        let identifier = ShareData.sharedInstance.detailContact[indexPath.row].identifier
        groupItem.indentifier = identifier
        groupItem.phoneNumber = object.phone
        if listContact.contains(groupItem) {
            for i in 0..<listContact.count{
                let contact = listContact[i]
                if contact.indentifier == identifier{
                    listContact.remove(at: i)
                    break
                }
            }
        }else{
            listContact.append(groupItem)
        }
        tbvContent.reloadData()
    }
    
    func selectAllRows() {
        for section in 0..<tbvContent.numberOfSections {
            for row in 0..<tbvContent.numberOfRows(inSection: section) {
                tbvContent.selectRow(at: IndexPath(row: row, section: section), animated: false, scrollPosition: .none)
            }
        }
    }
    
}

