//
//  InstantsViewController.swift
//  InstanChat
//
//  Created by Iranildo C. Silva on 05/04/20.
//  Copyright © 2020 Local Oeste Software House. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class InstantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    var instans : [Instants] = []
    
    let autenticacao = Auth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let idUsuarioLogado = autenticacao.currentUser?.uid{
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let instants = usuarios.child(idUsuarioLogado).child("instants")
            
            
            //Cria Ouvinte para snaps
            instants.observe(DataEventType.childAdded) { (snapshot)in
                
                let dados = snapshot.value as? NSDictionary
                
                let instan = Instants()
                instan.identificador = snapshot.key
                instan.nome =  dados?["nome"] as! String
                instan.descricao = dados?["descricao"] as! String
                instan.urlImagem = dados?["urlImagem"] as! String
                instan.idImagem = dados?["idImagem"] as! String
                
                self.instans.append(instan)
                self.tableView.reloadData()
                
                 
            }
            
            /*Adiciona um ouvinte para o item removido*/
            instants.observe(DataEventType.childRemoved) { (snapshot) in
                
                var indice = 0
                for insta in self.instans{
                    if insta.identificador == snapshot.key{
                        self.instans.remove(at: indice)
                        
                    }
                    indice = indice + 1
                }
               
                self.tableView.reloadData()
            }
            
            
            
        }
        
    }
    

    @IBAction func btSair(_ sender: Any) {
        
        do{
            try self.autenticacao.signOut()
            dismiss(animated: true, completion: nil)
        }catch{
            print("Erro ao deslogar o usuário...")
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let totalInstans = instans.count
        if totalInstans > 0{
            let inst = self.instans[indexPath.row]
            self.performSegue(withIdentifier: "SegueDetalhesInstan", sender: inst)
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueDetalhesInstan"{
            let detalhesInstanViewController = segue.destination as! DetalhesInstanViewController
            
            detalhesInstanViewController.instans = sender as! Instants
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          let totalInstans = instans.count
          if totalInstans == 0{
            return 1
        }
        
          return  totalInstans
        
    }
    
    
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
          let totalInstans = instans.count
          if totalInstans == 0{
            celula.textLabel?.text = "no instan for you"
            celula.detailTextLabel?.text = ""
            celula.imageView?.isHidden = true
          }else{
            
            let inst = self.instans[indexPath.row]
            celula.textLabel?.text = inst.nome
            celula.detailTextLabel?.text = inst.descricao
            celula.imageView?.isHidden = false
        }
        
        return celula
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
