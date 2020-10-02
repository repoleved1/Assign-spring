//
//  LAContactViewController.swift
//  LockApp
//
//  Created by Feitan on 8/19/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import RealmSwift

class LAContactViewController: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    let getContact = GetContact()
    var searchActive : Bool = false
    let ramdomColorView = RandomColor()
    var filterName = [ItemFavorites]()
    var checkFavorite: Bool = true
    var getAll:Results<ArrayFavorite>!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "ContactTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(areloadContact), name:
            NSNotification.Name(rawValue: "reloadContact"), object: nil)
        
        requestAccess { (bools) in
            if bools {
                self.getContact.showContact {
                    self.count =  ShareData.sharedInstance.arrContact.count
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let store = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        @unknown default:
            completionHandler(false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getAll = DatabaseService.sharedInstance.getAllArrFavorites()
        DispatchQueue.global(qos: .background).async {
            self.count =  ShareData.sharedInstance.arrContact.count
            self.getContact.showContact {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            completionHandler(false)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
    }
    
    @objc func areloadContact() {
        GCDCommon.mainQueue {
            self.tableView.reloadData()
        }
    }
    
}

extension LAContactViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filterName.count
        }
        return self.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        
        var arrContact = [ItemFavorites]()
        if searchActive {
            arrContact = filterName
        } else {
            arrContact = ShareData.sharedInstance.arrContact
        }
        
        if arrContact.count > 0 {
            cell.nameNumber.text = arrContact[indexPath.row].giveName + " " + arrContact[indexPath.row].familyName
            
            var text = ""
            let givenName: Character! =  arrContact[indexPath.row].giveName.first
            let familyName: Character! = arrContact[indexPath.row].familyName.first
            
            print("givenName", givenName as Any)
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension LAContactViewController: CNContactViewControllerDelegate {
    
}
