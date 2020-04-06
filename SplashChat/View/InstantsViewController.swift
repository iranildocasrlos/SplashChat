//
//  InstantsViewController.swift
//  InstanChat
//
//  Created by Iranildo C. Silva on 05/04/20.
//  Copyright © 2020 Local Oeste Software House. All rights reserved.
//

import UIKit
import FirebaseAuth

class InstantsViewController: UIViewController {
    
    let autenticacao = Auth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btSair(_ sender: Any) {
        
        do{
            try self.autenticacao.signOut()
            dismiss(animated: true, completion: nil)
        }catch{
            print("Erro ao deslogar o usuário...")
        }
        
        
        
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
