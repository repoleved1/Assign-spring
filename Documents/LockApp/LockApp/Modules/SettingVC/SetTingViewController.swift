//
//  SetTingViewController.swift
//  LockApp
//
//  Created by Feitan on 7/30/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

protocol SetTingViewControllerDelegate {
    func openCellSlideRightMenu(index: Int)
}

struct SettingModel {
    var title: String
}

class SetTingViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    var cells: [SettingModel] = []
    var delegate: SetTingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        tableView.register(UINib(nibName: "TouchIDTableViewCell", bundle: nil), forCellReuseIdentifier: "TouchIDTableViewCell")
        
        let cell1 = SettingModel(title: "Change Passcode")
        let cell2 = SettingModel(title: "Privacy Policy")
        let cell3 = SettingModel(title: "Term Of Use")
        let cell4 = SettingModel(title: "Support")
        let cell5 = SettingModel(title: "Share This App")
        
        cells = [cell1, cell2, cell2, cell3, cell4, cell5]
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SetTingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouchIDTableViewCell", for: indexPath) as! TouchIDTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
                   
                   cell.imageBack.image = UIImage.init(named: "ic_setting_back")
                   cell.setting = cells[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            let navi = UINavigationController(rootViewController: HomeViewController.instance())
//            navi.isNavigationBarHidden = true
//            TAppDelegate.menuContainerViewController?.centerViewController = navi
//            break
//        default:
//            break
//        }
        
        delegate?.openCellSlideRightMenu(index: indexPath.row)

    }
    
    
}
