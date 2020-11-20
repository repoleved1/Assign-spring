//
//  HomeViewController.swift
//  SantaCall
//
//  Created by Feitan on 11/2/20.
//

import UIKit

class HomeViewController: BaseViewController {

    //MARK: -- IBOutlet
    @IBOutlet weak var lbDay1: UILabel!
    @IBOutlet weak var lbDay2: UILabel!
    @IBOutlet weak var lbDay3: UILabel!
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbUnit: UILabel!
    
    //MARK: -- Variables
    var timer = Timer()
    
    //MARK: -- Viewlife cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: false)
        timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)

    }

    //MARK: -- Action
    @IBAction func openSettingVC(_ sender: Any) {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @IBAction func openGetCallVC(_ sender: Any) {
        let getCallVC = GetCallViewController()
        getCallVC.typeCall = .phone
        navigationController?.pushViewController(getCallVC, animated: true)
    }
    
    @IBAction func openCallVideoVC(_ sender: Any) {
        let callVideoVC = VideoCallViewController.init(nibName: String(describing: VideoCallViewController.self).nibWithNameiPad(), bundle: nil)
        callVideoVC.typeCall = .video
        navigationController?.pushViewController(callVideoVC, animated: true)
    }
    
    @IBAction func openMessagesVC(_ sender: Any) {
        let chatVC = ChatViewController()
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func openHistoryVC(_ sender: Any) {
        let historyVC = HistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    //MARK: -- Methods support
    @objc func countdown() {
        let date = NSDate()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.second, .hour, .minute, .month, .year, .day], from: date as Date)
        
        let currentDate = calendar.date(from: components)
        
        let userCalendar = Calendar.current
        
        // here we set the due date. When the timer is supposed to finish
        let competitionDate = NSDateComponents()
        competitionDate.year = components.year!
        competitionDate.month = 12
        competitionDate.day = 24
        competitionDate.hour = 00
        competitionDate.minute = 00
        competitionDate.second = 00
        let competitionDay = userCalendar.date(from: competitionDate as DateComponents)!
        
        //here we change the seconds to hours,minutes and days
        let CompetitionDayDifference = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate!, to: competitionDay)
        
        //finally, here we set the variable to our remaining time
        let day1Left = CompetitionDayDifference.day!/100
        let day2Left = CompetitionDayDifference.day!/10
        let day3Left = CompetitionDayDifference.day! - day1Left*100 - day2Left*10

        let hoursLeft = CompetitionDayDifference.hour ?? 0
        let minutesLeft = CompetitionDayDifference.minute ?? 0
        let secondLeft = CompetitionDayDifference.second ?? 0
        
        self.lbDay1.text = String(day1Left)
        self.lbDay2.text = String(day2Left)
        self.lbDay3.text = String(day3Left)
        self.lbTime.text = "\(hoursLeft)    :    \(minutesLeft)    :    \(secondLeft)"
        self.lbUnit.text = "Hours             Minutes             Seconds"

    }
}
