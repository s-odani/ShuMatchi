//
//  RegisterViewController.swift
//  ChatApp3
//
//  Created by apeirogon on 2020/07/24.
//  Copyright © 2020 ShunsukeOdani. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //firebaseにユーザを作成する（登録する）
    
    @IBAction func registerNewUser(_ sender: Any) {
        
        //アニメーションのスタート
        
        //新規登録
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            if error != nil{
                print(error)
            }else{
                print("ユーザの作成が成功しました")
                //アニメーションのストップ
                //関数の中に関数を入れる場合は自分自身を指すself
                self.stopAnimation()
                //画面をチャット画面に遷移させる
                //self.performSegue(withIdentifier: "profile", sender: nil)
                
            }
        }
    }
    
    func startAnimation(){
        
        let animation = Animation.named("loading")
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/1.5)
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        view.addSubview(animationView)
    }
    
    func stopAnimation(){
        
        animationView.removeFromSuperview()
        
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
