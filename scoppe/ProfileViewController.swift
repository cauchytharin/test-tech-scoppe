//
//  ProfileViewController.swift
//  scoppe
//
//  Created by Billy Cauchy-Tharin on 21/01/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getUserInfo() {
        guard let user = user else { return }
        let urlString = "https://reqres.in/api/users/\(user.id)"
        AF.request(urlString, method: .get)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let imageUrl = json["data"]["avatar"].string {
                        self.user?.imageUrl = imageUrl
                        self.getImageFromUrl()
                    }
                    if let userName = json["data"]["first_name"].string {
                        self.welcomeLabel.text = "Bienvenue \(userName)"
                        self.user?.firstName = userName
                    }
                case .failure(let error):
                    print("Request user info error: \(error)")
                }
        }
    }
    
    func getImageFromUrl() {
        guard let urlString = user?.imageUrl, let url = URL(string: urlString) else { return }
        let data = try? Data(contentsOf: url)
        if let imageData = data, let img = UIImage(data: imageData) {
            self.userImageView.image = img
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
