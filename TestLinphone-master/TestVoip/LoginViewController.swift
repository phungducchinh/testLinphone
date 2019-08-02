//
//  LoginViewController.swift
//  TestVoip
//
//  Created by Edmund on 8/2/19.
//  Copyright © 2019 Saeid. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var imvLogo: UIImageView!
    @IBOutlet weak var vwPass: UIView!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var vwUserName: UIView!
    @IBOutlet weak var txtUserName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func settingUI(){
        imvLogo.layer.cornerRadius = imvLogo.frame.height/2
        self.vwPass.UnderLine(.lightGray, 1)
        self.vwUserName.UnderLine(.lightGray, 1)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
