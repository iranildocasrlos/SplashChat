//
//  ViewController.swift
//  SplashChat
//
//  Created by Iranildo C. Silva on 06/03/20.
//  Copyright © 2020 Local Oeste Software House. All rights reserved.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let autenticacao  = Auth.auth()
        
        autenticacao.addStateDidChangeListener { (autenticar, usuario) in
            if let usuarioLogado = usuario{
                self.performSegue(withIdentifier: "SegueloginAutomatico", sender: nil)
            }
        }
        
        
    }
    
    
    
    @IBAction func btLogin(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SegueLogin", sender: nil)
        
        
    }
    
    
    
    
    @IBAction func btCreate(_ sender: Any) {
        
        self.performSegue(withIdentifier: "SegueCreateAccount", sender: nil)
               
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    


}

