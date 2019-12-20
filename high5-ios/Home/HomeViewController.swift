//
//  HomeViewController.swift
//  high5
//
//  Created by Arnaud Costa on 18/11/2018.
//  Copyright © 2018 Arnaud Costa. All rights reserved.
//

//import GoogleMobileAds
import UIKit

class HeadlineHomeTableViewCell: UITableViewCell {
    @IBOutlet weak var goupeName: UILabel!
    @IBOutlet weak var groupeDate: UILabel!
    @IBOutlet weak var groupePlace: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var nbUsers: UILabel!
    @IBOutlet weak var eventPicture: UIImageView!
}

class HeadlineHomeTableViewMyEventsCell: UITableViewCell {
    @IBOutlet weak var title_: UILabel!
}

class HomeViewController: UIViewController {

//    lazy var adBannerView: GADBannerView = {
//        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
//        adBannerView.adUnitID = "ca-app-pub-3599785318600764/2047234523"
//        adBannerView.delegate = self
//        adBannerView.rootViewController = self
//
//        return adBannerView
//    }()
    
    @IBOutlet private weak var tableView: UITableView!
    private var events_ = [EventModel]()
    let viewModel = HomeViewModel(databaseManager: FirebaseDatabaseManager(), userInfo: UserInfoFirebase(), authManager: FirebaseAuth())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!viewModel.userIsLogged) {
            displayView(viewId: "loginVC")
            return
        } else {
            viewModel.getUser(uid: viewModel.currentUserUid!) { (user) in
                if (user == nil) {
                    self.displayView(viewId: "completUserProfileVC")
                    return
                } else {
                    //self.adBannerView.load(GADRequest())
                    self.viewModel.getEvents { [weak self] events in
                        self?.events_ = events ?? []
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return events_.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (events_[indexPath.row].id.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myEventsCell", for: indexPath) as! HeadlineHomeTableViewMyEventsCell
                cell.title_.text = events_[indexPath.row].name
                cell.selectionStyle = .none
                return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! HeadlineHomeTableViewCell
        let event = events_[indexPath.row]
        cell.goupeName?.text = event.name.uppercased()
        cell.groupeDate?.text = event.eventAt
        cell.groupePlace?.text = event.place
        cell.nbUsers.text = String(event.userIds.count) + "/" + String(event.userMaxNumber.intValue)
        viewModel.getImage(event.groupePicture, cell.eventPicture)
        if (event.createdBy == viewModel.currentUserUid || event.userIds.contains(viewModel.currentUserUid!)) {
            cell.btn.setTitle("Chat", for: .normal)
        } else {
            cell.btn.setTitle("Rejoindre", for: .normal)
        }
        cell.selectionStyle = .none
        return cell
    }

}

extension HomeViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt: IndexPath) {
        guard events_[didSelectRowAt.row].id != "" else {
            return
        }
        if (events_[didSelectRowAt.row].createdBy == viewModel.currentUserUid || events_[didSelectRowAt.row].userIds.contains(viewModel.currentUserUid!)) {
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
            newVC.eventId = events_[didSelectRowAt.row].id
            newVC.groupName = events_[didSelectRowAt.row].name
            navigationController?.show(newVC, sender: nil)
        } else {
            let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsVC") as! EventDetailsViewController
            newVC.eventId_ = events_[didSelectRowAt.row].id
            newVC.btnTitle_ = "REJOINDRE"
            navigationController?.show(newVC, sender: nil)
        }
    }
}

//extension HomeViewController: GADBannerViewDelegate {
//    
////    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        return adBannerView
////    }
////    
////    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
////        
////        return adBannerView.frame.height
////    }
//
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
//        bannerView.transform = translateTransform
//        UIView.animate(withDuration: 0.5) {
//            bannerView.transform = CGAffineTransform.identity
//        }
//    }
//    
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print(error)
//    }
//}
