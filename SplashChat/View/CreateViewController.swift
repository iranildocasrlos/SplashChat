//
//  CreateViewController.swift
//  InstanChat
//
//  Created by Iranildo C. Silva on 23/03/20.
//  Copyright © 2020 Local Oeste Software House. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



class CreateViewController: UIViewController {
    
    
    @IBOutlet weak var campoNome: UITextField!
    
    
    @IBOutlet weak var campoEmail: UITextField!
    
    
    @IBOutlet weak var campoSenha: UITextField!
    
    
    let autenticacao = Auth.auth()
    let database = Database.database().reference().child("usuarios")
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    
    func exibirMensagem(titulo: String, mensagem : String ){
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let acaoCancelar = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alerta.addAction(acaoCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    
    @IBAction func btCreate(_ sender: Any) {
        
        if let nome = self.campoNome.text{
            if let email = self.campoEmail.text{
                if let senha = self.campoSenha.text{
                    
                    autenticacao.createUser(withEmail: email, password: senha) { (success, erro) in
                        if success != nil{
                            self.exibirMensagem(titulo: "Success", mensagem: "Successfully authenticated ... ")
                            let dadosUsuario  = [
                            
                                "nome" : nome,
                                "email" : email,
                                "senha" : senha
                            
                            
                            ] as? [String : Any]
                            
                            
                            self.database.child(self.autenticacao.currentUser!.uid).setValue(dadosUsuario)
                            print("Criado base de dados...")
                            self.performSegue(withIdentifier: "SegueCadastroPrincipal", sender: nil)
                        }
                    }
                }
            }
        }
        
       
        
    }
    
    
    
    @IBAction func btSair(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
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
