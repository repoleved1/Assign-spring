//
//  LALockAppViewController.swift
//  LockApp
//
//  Created by Feitan on 8/4/20.
//  Copyright © 2020 SingleViewApp. All rights reserved.
//

import UIKit

class LALockAppViewController: BaseVC, DetailAppViewControllerDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewLayout: UIView!
    @IBOutlet weak var btSelect: UIButton!
    @IBOutlet weak var btAdd: UIButton!
    
    var isDelete = false
    var temArr = [StoreObj]()
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        
        searchBar.delegate = self
        collectionView.register(ListAppCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        StoreManager.shared.loadLocalData()
        temArr = StoreManager.shared.arrSearch
        collectionView.reloadData()
        collectionView.backgroundView = StoreManager.shared.arrSearch.count > 0 ? nil : Common.viewNoData()
    }
    
    func setupUI() {
        
        // View Layout
        viewLayout.clipsToBounds = true
        viewLayout.layer.cornerRadius = 50
        viewLayout.layer.maskedCorners = [.layerMinXMinYCorner]
        
        
        // Search Bar
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.setImage(UIImage.init(named: "ic_delete_searchBar"), for: .clear, state: .normal)
        searchController.searchBar.setImage(UIImage.init(named: "ic_delete_searchBar"), for: .clear, state: [.highlighted, .selected])

        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "Search App", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(hex: "ECDCFE")])
            
            let imageV = textfield.leftView as! UIImageView
            imageV.image = imageV.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            imageV.tintColor = UIColor.init(hex: "ECDCFE")
            

        }
    }
    
    func useTouchIDForApp(index: Int, isOn: String) {
        temArr[index].touchID = isOn
        collectionView.reloadData()
        
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    
    @IBAction func selectApp(_ sender: Any) {
        
        self.isDelete = !self.isDelete
        self.collectionView.reloadData()
        if self.isDelete {
                    btSelect.setTitle("Done", for: .normal)
        } else {
                    btSelect.setTitle("Select", for: .normal)

        }
    }
    
    @IBAction func openAddVC(_ sender: Any) {
        if PaymentManager.shared.isPurchaseStore() {
            let vc = LAAddAppViewController.init(nibName: "LAAddAppViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            //            let viewController = StoreViewController.init(nibName: String.init(describing: StoreViewController.self).nibWithNameiPad(), bundle: nil)
            //            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension LALockAppViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return isIPad ? CGSize(width: collectionView.frame.width, height: 100) : CGSize(width: collectionView.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StoreManager.shared.arrSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ListAppCollectionViewCell
        cell.config(StoreManager.shared.arrSearch[indexPath.item], isDelete)
        
        cell.handleDeleteApp = {
            StoreManager.shared.arrSearch[indexPath.item].deleteStore()
            self.loadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailAppViewController.init(nibName: "DetailAppViewController", bundle: nil)
        vc.isEdit = true
        vc.index = indexPath.row
        vc.storeObj = StoreManager.shared.arrSearch[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

extension LALockAppViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        StoreManager.shared.arrSearch = temArr.filter({ (objs) -> Bool in
            return objs.name.uppercased().contains(searchText)
        })
        
        if searchText.count == 0 {
            StoreManager.shared.arrSearch = temArr
        }
        
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension LALockAppViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = true
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false

    }
}
