//
//  UsuariosTableViewController.swift
//  InstanChat
//
//  Created by Iranildo C. Silva on 08/04/20.
//  Copyright © 2020 Local Oeste Software House. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UsuariosTableViewController: UITableViewController {
    
    var usuarios : [Usuario] = []
    var urlImagem = ""
    var descricao = ""
    var idImagem = ""
    let authorization = "key=AAAAuM2FzUw:APA91bGE6g8ELIvSOON4yElZcfEBHu_3Jx6zwcOPqdKSzg6Gv4CTYO1qGarnh6fOPAMdije8Im21fxud8BGJQS6t43kBdTRCryM7bVUiBk-0MV6SyJE-j6WYWqevszIKzmnyp32D67qE"
    
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = Database.database().reference()
        let usuarios = database.child("usuarios")
        
        let idUsuarioLogado = Auth.auth().currentUser?.uid
        let minhaLista = usuarios.child(idUsuarioLogado!).child("friends")
        
        /* Adiciona evento novo usuarios a lista*/
        minhaLista.observe(DataEventType.childAdded) { (snapshot) in
           // print(snapshot)
            
            let dados  = snapshot.value as? NSDictionary
            
            let emailUsuario = dados?["email"] as! String
            let nomeUsuario = dados?["nome"] as! String
            let idUsuario = snapshot.key
            
            let usuario = Usuario(email: emailUsuario, nome: nomeUsuario, uid: idUsuario)
            
            
                self.usuarios.append(usuario)
            
            
            self.tableView.reloadData()
            
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.usuarios.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        // Configure the cell...
        let usuario = self.usuarios[indexPath.row]
        celula.textLabel?.text = usuario.nome
        celula.detailTextLabel?.text = usuario.email
        
        return celula
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuarioSelecionado = self.usuarios[indexPath.row]
        let idUsuarioSelecionado = usuarioSelecionado.uid
        let auth = Auth.auth()
        
        let database = Database.database().reference()
        let usuarios = database.child("usuarios")
        
        if let idUsuarioLogado = auth.currentUser?.uid{
            if let emailUsuarioLogado  = auth.currentUser?.email{
                
                let usuarioLogado = usuarios.child(idUsuarioLogado)
                usuarioLogado.observeSingleEvent(of: DataEventType.value) { (snapshot) in
                    
                    let snaps = usuarios.child(idUsuarioSelecionado).child("instants")
                    
                    let dados =  snapshot.value as? NSDictionary
                    
                    
                    let dadosSnaps = [
                        
                        "de": emailUsuarioLogado,
                        "nome": dados?["nome"] as! String,
                        "descricao": self.descricao,
                        "urlImagem": self.urlImagem,
                        "idImagem": self.idImagem
                        
                    ]
                    
                    snaps.childByAutoId().setValue(dadosSnaps)
                    self.getToken(nome: dados?["nome"] as! String, idAmigo : idUsuarioSelecionado )
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }
                
            }
        }
        
        
    }
    
    
    
    @IBAction func addFriends(_ sender: Any) {
        
        let alerta = UIAlertController(title: "Email  contact", message: "Enter a contact's email address for search", preferredStyle: .alert)
        
        alerta.addTextField { (textField) in
            textField.text = ""
        }
        
        let acaoCancelar = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let acaoConfirmar = UIAlertAction(title: "OK", style: .default) { (confirmar) in
            
            let textField = alerta.textFields![0] 
            print("Text field: \(textField.text)")
            let emailFriend  = textField.text
            
            let idUsuarioLogado = Auth.auth().currentUser?.uid as! String
            let database = Database.database().reference()
            let  usuarios = database.child("usuarios").queryOrdered(byChild: "email").queryEqual(toValue: emailFriend)
            
            usuarios.observeSingleEvent(of: DataEventType.childAdded) { (snapshot) in
                if snapshot.exists(){
                    if let dados = snapshot.value as? [String : Any]{
                        let idAmigo = snapshot.key
                        if let nomeAmigo = dados["nome"] as? String{
                            
                            let meusAmigos = database.child("usuarios").child(idUsuarioLogado).child("friends").child(idAmigo)
                            
                            //Cria insere dados dos amigos
                            let dadosAmigo = [
                                "dAmigo" : idAmigo,
                                "nome"  : nomeAmigo,
                                "email" : emailFriend
                                ]
                           
                            meusAmigos.ref.updateChildValues(dadosAmigo) { (erro, reference) in
                                if erro == nil{
                                     self.exibirMensagem(titulo: "Successfuly", mensagem: "Friend add the your DataBase...")
                                }else{
                                     self.exibirMensagem(titulo: "Erro", mensagem: "Error, not add")
                                }
                            }
                        }
                  
                    }
                    
                }
            }
            
            
            
        }
        
        alerta.addAction(acaoConfirmar)
        alerta.addAction(acaoCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    func exibirMensagem(titulo: String, mensagem : String ){
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
       
        let acaoCancelar = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        //let acaoConfirmar = UIAlertAction(title: "OK", style: .default) { (confirmar) in
            
            
     //   }
        
        alerta.addAction(acaoCancelar)
        //alerta.addAction(acaoConfirmar)
        present(alerta, animated: true, completion: nil)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func upStream(title : String, body : String ,  authorization : String, token : String, nome : String){
        
        
        //   HTTP Post in Swift capturing the errors
        let url = NSURL(string: "https://fcm.googleapis.com/fcm/send")
        let postParams: [String : Any] = ["to": token, "notification": ["body": body, "title": title]]
        
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
            print("My paramaters: \(postParams)")
        }
        catch
        {
            print("Caught an error: \(error)")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let realResponse = response as? HTTPURLResponse
            {
                if realResponse.statusCode != 200
                {
                    print("Not a 200 response")
                }else{
                    print(" 200 response")
                }
            }
            
            if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String
            {
                print("POST: \(postString)")
            }
        }
        
        task.resume()
    }
    
    
    
    
    
    func getToken(nome : String, idAmigo : String ){
        
        let database = Database.database().reference()
        let amigo = database.child("usuarios")
        
        //let queryOperacional = usuarios.queryOrdered(byChild: "bairro").queryEqual(toValue: bairroComparar)
        
        amigo.observe(.childAdded) { (snapshot) in
            if let dados = snapshot.value as? [String: Any]{
                if let id = snapshot.key as? String{
                    if idAmigo == id{
                        
                        if let tokenAmigo = dados["token"] as? String{
                                    self.token = tokenAmigo
                                    self.upStream(title: "New Message", body: "\(nome)", authorization: self.authorization, token: self.token, nome: nome)
                                    
                            
                        }
                        
                    }
                }
                        
            }
        }
        
        
        
        
        
    }
    
    
    
    
    
}
