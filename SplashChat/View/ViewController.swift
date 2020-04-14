//
//  ViewController.swift
//  SplashChat
//
//  Created by Iranildo C. Silva on 06/03/20.
//  Copyright © 2020 Local Oeste Software House. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let autenticacao  = Auth.auth()
        
        autenticacao.addStateDidChangeListener { (autenticar, usuario) in
            if let usuarioLogado = usuario{
                self.performSegue(withIdentifier: "SegueloginAutomatico", sender: nil)
                
                //DataBase
                
                let database = Database.database().reference()
                let usuarios = database.child("usuarios").child(usuarioLogado.uid)
                
                print("usuario logado : id \(usuarioLogado.uid)")
                
                usuarios.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dados = snapshot.value as? NSDictionary
                    
                    if dados != nil{
                        
                        let ud = UserDefaults.standard
                        
                        if let dados = ud.data(forKey: "fcmToken"), let tokenSalvo = try?
                            JSONDecoder().decode([String: String].self, from: dados){
                            
                            
                            
                            if   let  tokenFCM = tokenSalvo as? [String : Any]{
                                
                                
                                let dadosUsuario = tokenFCM
                                    as [String : Any]
                                
                                
                                usuarios.ref.updateChildValues(dadosUsuario)
                                
                            }
                        }
                    }
                })
                //Fim DataBase
            }//Fim didStateListener
        
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

