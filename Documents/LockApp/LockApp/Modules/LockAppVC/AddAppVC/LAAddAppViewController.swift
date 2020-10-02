//
//  LAAddAppViewController.swift
//  LockApp
//
//  Created by Feitan on 8/4/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KRProgressHUD

class LAAddAppViewController: BaseVC {
    
    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navi: NavigationView!
    
    var arrSearch = [StoreAppObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        tableView.register(SearchAppCellTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundView = self.arrSearch.count > 0 ? nil : Common.viewNoData()
    }
    
    
    @objc func searchApp(str: String) {
        AF.request("https://itunes.apple.com/search?term=\(str.encode())&country=US&entity=software").response { response in
            
            if((response.data) != nil) {
                let swiftyJsonVar = JSON(response.data as Any)
                print(swiftyJsonVar)
                guard let jsonArray = swiftyJsonVar["results"].arrayObject else {
                    return
                }
                self.arrSearch = jsonArray.compactMap{StoreAppObj($0 as! [String : Any])}
                self.tableView.reloadData()
                self.tableView.backgroundView = self.arrSearch.count > 0 ? nil : Common.viewNoData()
                KRProgressHUD.dismiss()
            }
        }
    }
    
    func setupUI() {
        
        // View Layout
        viewLayout.clipsToBounds = true
        viewLayout.layer.cornerRadius = 50
        viewLayout.layer.maskedCorners = [.layerMinXMinYCorner]
        
        // Search App
        searchBar.backgroundImage = UIImage()
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "Search App", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension LAAddAppViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchAppCellTableViewCell
        cell.config(arrSearch[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50*heightRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailAppViewController.init(nibName: "DetailAppViewController", bundle: nil)
        vc.appObj = arrSearch[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension LAAddAppViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           KRProgressHUD.show()
           searchApp(str: searchBar.text ?? "")
           searchBar.endEditing(true)
       }
       
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           searchApp(str: searchText)
       }
}

struct StoreAppObj {
    var trackId: Int32
    var bundleId: String
    var trackName: String
    var artistId: Int32
    var artistName: String
    var artworkUrl512: String
    var sellerUrl: String
    var trackViewUrl: String
    var touchID: String
    
    init(trackId: Int32, bundleId: String, trackName: String, artistId: Int32, artistName: String, artworkUrl512: String, sellerUrl: String, trackViewUrl: String, touchID: String) {
        self.trackId = trackId
        self.bundleId = bundleId
        self.trackName = trackName
        self.artistId = artistId
        self.artistName = artistName
        self.artworkUrl512 = artworkUrl512
        self.sellerUrl = sellerUrl
        self.trackViewUrl = trackViewUrl
        self.touchID = touchID
    }
    
    init(_ dictionary: [String: Any]) {
        self.trackId = dictionary["trackId"] as? Int32 ?? 0
        self.artistId = dictionary["artistId"] as? Int32 ?? 0
        self.bundleId = dictionary["bundleId"] as? String ?? ""
        self.trackName = dictionary["trackName"] as? String ?? ""
        self.artistName = dictionary["artistName"] as? String ?? ""
        self.artworkUrl512 = dictionary["artworkUrl512"] as? String ?? ""
        self.sellerUrl = dictionary["sellerUrl"] as? String ?? ""
        self.trackViewUrl = dictionary["trackViewUrl"] as? String ?? ""
        self.touchID = dictionary["touchID"] as? String ?? "F"
    }
}
