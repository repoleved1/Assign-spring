//
//  GetCallViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/2/20.
//

import UIKit

class GetCallViewController: BaseViewController {

    //MARK: -- IBOutlet
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var igArrow: UIImageView!
    @IBOutlet weak var btCall: UIButton!
    
    //MARRK: -- Propety
    var pageVC: UIPageViewController?
    var contentVC = ContentViewController()
    var santaClaus = santaClauses[0]
    var typeCall: TypeCall = .phone

    var listImageContent = ["ig_getcall1", "ig_getcall2", "ig_getcall4", "ig_getcall3"]
    var lissImageButton = ["ic_phone", "ic_call_orange", "ic_call_yellow", "ic_call_milk"]
    lazy var listVC: [UIViewController] = {
        return []
    }()
    
    //MARK: -- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        configDataPageVC()
        let currentIndexSanta = UserDefaults.standard.integer(forKey: CURRENT_SANTA)
        print("current index of santa: \(currentIndexSanta)")
        santaClaus = santaClauses[currentIndexSanta]
    }

    
    override func viewWillAppear(_ animated: Bool) {
        if typeCall == .phone {
            lbTitle.text = "Get Call"
        } else {
            lbTitle.text = "Call Video"
        }
    }
    
    private func setupUI() {
        btCall.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 3,
          delay: 0,
          usingSpringWithDamping: 0.2,
          initialSpringVelocity: 6.0,
          options: .allowUserInteraction,
          animations: { [weak self] in
            self?.btCall.transform = .identity
          },
          completion: { finished in
            self.setupUI()
          })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    private func configDataPageVC() {
        for i in 0...3 {
            let vc = ContentViewController()
            vc.nameImage = listImageContent[i]
            listVC.append(vc)
            pageVC = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            pageVC?.dataSource = self
            pageVC?.delegate = self
            pageVC?.view.backgroundColor = .clear
            pageVC?.view.frame = CGRect(x: 0, y: 0, width: viewContent.frame.width, height: viewContent.frame.height)

            viewContent.addSubview((pageVC?.view)!)
            vc.delegate = self
            if let firstVC = listVC.first as? ContentViewController {
                pageVC?.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            }
        }
        configPageControl()
    }
    
    private func configPageControl() {
        pageControl.numberOfPages = 4
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        santaClaus = santaClauses[0]
    }
    
    @IBAction func openDetailGetCallVC(_ sender: Any) {
        let detailVC = DetailGetCallViewController.init(nibName: String(describing: DetailGetCallViewController.self).nibWithNameiPad(), bundle: nil)
        detailVC.santaClaus = santaClaus
        detailVC.typeCall = typeCall
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func openDetailVC() {
        let detailVC = DetailGetCallViewController()
        detailVC.santaClaus = santaClaus
        detailVC.typeCall = typeCall
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension GetCallViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let VCindex = listVC.firstIndex(of: viewController ) else {
            return nil
        }
        let preriousIndex = VCindex - 1
        guard preriousIndex >= 0 else {
//                    return listVC[listVC.count - 1]
            return nil
        }
        guard listVC.count > preriousIndex else {
            return nil
        }
        return listVC[preriousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let VCindex = listVC.firstIndex(of: viewController ) else {
            return nil
        }
        let nextIndex = VCindex + 1
        guard listVC.count != nextIndex else {
            return nil
//                    return listVC[0]
        }
        guard listVC.count > nextIndex else {
            return nil
        }
        return listVC[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewController = pageViewController.viewControllers?[0] as? ContentViewController, let index = listVC.firstIndex(of: viewController) {
            pageControl.currentPage = index
            let animation = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.type = .fade
            animation.duration = 0.4
            switch index {
            case 0:
                btCall.setImage(UIImage(named: lissImageButton[0]), for: .normal)
            case 1:
                btCall.setImage(UIImage(named: lissImageButton[1]), for: .normal)
            case 2:
                btCall.setImage(UIImage(named: lissImageButton[2]), for: .normal)
            case 3:
                btCall.setImage(UIImage(named: lissImageButton[3]), for: .normal)
            default:
                break
            }
            santaClaus = santaClauses[index]
            
            UserDefaults.standard.set(index, forKey: CURRENT_SANTA)
        }
    }
}

extension GetCallViewController: ContentViewControllerDelegate {
    func setTypePhoneCall() {
        let detailVC = DetailGetCallViewController.init(nibName: String(describing: DetailGetCallViewController.self).nibWithNameiPad(), bundle: nil)
        detailVC.santaClaus = santaClaus
        detailVC.typeCall = typeCall
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
