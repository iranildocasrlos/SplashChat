//
//  LoginViewController.swift
//  InstanChat
//
//  Created by Iranildo C. Silva on 23/03/20.
//  Copyright © 2020 Local Oeste Software House. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var campoEmail: UITextField!
    
    @IBOutlet weak var campoSenha: UITextField!
    
    let autenticacao = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    //Verifica se os campos do formulário foram preenchidos
    func validarCampos() -> String{
        
        if (self.campoEmail.text?.isEmpty)!{
            return  "E-mail"
        }else if(self.campoSenha.text?.isEmpty)!{
            return "senha"
        }
        return ""
    }
    
    
    @IBAction func entrar(_ sender: Any) {
        
        
        let retorno = validarCampos()
        
        if retorno == "" {
            
            if let emailR = self.campoEmail.text{
                if let senhaR = self.campoSenha.text{
                    
                    autenticacao.signIn(withEmail: emailR, password: senhaR) { (result, error) in
                        if result == nil{
                            
                            let alerta = UIAlertController(title: "Atenção! ", message: "não existe conta cadastrada com esse mail ou conta foi encerrada", preferredStyle: .alert)
                            
                            let acaoAlerta = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alerta.addAction(acaoAlerta)
                            self.present(alerta, animated: true, completion: nil)
                            
                            
                        }else{
                            
                            if let mensagemErro = error?.localizedDescription{
                                
                                
                                if mensagemErro.contains("no user record"){
                                    
                                    
                                    let alerta = UIAlertController(title: "Atenção! ", message: "não existe conta cadastrada com esse mail ou conta foi encerrada" , preferredStyle: .alert)
                                    
                                    let acaoAlerta = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    alerta.addAction(acaoAlerta)
                                    self.present(alerta, animated: true, completion: nil)
                                    
                                }
                                else if(mensagemErro.contains("The password is invalid")){
                                    
                                    let alerta = UIAlertController(title: "Atenção! ", message: "Erro senha" , preferredStyle: .alert)
                                    
                                    let acaoAlerta = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    alerta.addAction(acaoAlerta)
                                    self.present(alerta, animated: true, completion: nil)
                                    
                                    
                                }else{
                                    
                                    let alerta = UIAlertController(title: "Atenção! ", message: "O campo \(retorno) não foi preenchido", preferredStyle: .alert)
                                    
                                    let acaoAlerta = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    alerta.addAction(acaoAlerta)
                                    self.present(alerta, animated: true, completion: nil)
                                    
                                }
                                
                            }
                            
                            self.performSegue(withIdentifier: "SegueLoginPrincipal", sender: nil)
                            
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    func alerta(texto: String){
        let alerta = UIAlertController(title: "Atenção! ", message: texto , preferredStyle: .alert)
        
        let acaoAlerta = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alerta.addAction(acaoAlerta)
        self.present(alerta, animated: true, completion: nil)
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
