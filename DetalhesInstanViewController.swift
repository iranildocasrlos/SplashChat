//
//  DetalhesInstanViewController.swift
//  InstanChat
//
//  Created by Iranildo C. Silva on 10/04/20.
//  Copyright © 2020 Local Oeste Software House. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class DetalhesInstanViewController: UIViewController {
    
    
    @IBOutlet weak var detalhes: UILabel!
    
    @IBOutlet weak var imagem: UIImageView!
    
    @IBOutlet weak var contador: UILabel!
    
    var instans  = Instants()
    var tempo = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Id imagem --> \(self.instans.idImagem)")
        
        let url = URL(string: instans.urlImagem)
        detalhes.text = "Loading..."
        
        //Usando a biblioteca SDWebImage
        imagem.sd_setImage(with: url) { (imagem, erro, cache, url) in
            
            if erro == nil{
                
                self.detalhes.text = self.instans.descricao
                //Inicializa o Timer
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                    
                    //decrementa o timer
                    self.tempo = self.tempo - 1
                    
                    //Exibe timer na tela
                    self.contador.text  = String(self.tempo)
                    
                    if self.tempo == 0{
                        timer.invalidate()
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                    
                }
                
                
            }
            
            
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        let autenticacao = Auth.auth()
        
        if let idUsuarioLogado = autenticacao.currentUser?.uid{
            
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let instanRef = usuarios.child(idUsuarioLogado).child("instants")
            
            instanRef.child(self.instans.identificador).removeValue()
            
            //Remove as imagens do Storage
            let storage = Storage.storage().reference()
            let imagens = storage.child("imagens")
            
            imagens.child("\(self.instans.idImagem).jpg").delete { (erro) in
                
                if erro == nil{
                    print("Sucesso aoa excluir imagem")
                }else{
                    
                    print("Erro aoa excluir imagem \(erro.debugDescription)")
                }
                
            }
            
        }
        
        
    }

}
