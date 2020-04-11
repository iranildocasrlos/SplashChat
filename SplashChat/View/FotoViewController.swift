//
//  FotoViewController.swift
//  InstanChat
//
//  Created by Iranildo C. Silva on 05/04/20.
//  Copyright © 2020 Local Oeste Software House. All rights reserved.
//

import UIKit
import FirebaseStorage


class FotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imagem: UIImageView!
    
    @IBOutlet weak var descricao: UITextField!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    var imagePicker = UIImagePickerController()
    var idImagem = NSUUID().uuidString
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        self.nextButton.isEnabled = false
        self.nextButton.backgroundColor = UIColor.gray
    }
    
    
    @IBAction func albumFotos(_ sender: Any) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagem.image = imagemRecuperada
        
        imagePicker.dismiss(animated: true, completion: nil)
        self.nextButton.isEnabled = true
        self.nextButton.backgroundColor = UIColor(red: 0.949, green: 0.153, blue: 0.337, alpha: 1)
        
    }
    
    
    @IBAction func cameraOpen(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        
               self.nextButton.isEnabled = false
               self.nextButton.setTitle("loading...", for: .normal)
               
               let armazenamento = Storage.storage().reference()
               let imagens = armazenamento.child("imagens")
               
               //Recuperar a imagem
               if let imagemSelecionada = imagem.image  {
                   
                if let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.1) {
                       
                       imagens.child("\(self.idImagem).jpg").putData(imagemDados, metadata: nil, completion: { (metaDados, erro) in
                           
                           if erro == nil {
                               
                               print("Sucesso ao fazer o upload do Arquivo")
                            
                            let imagemRecuperada = imagens.child("\(self.idImagem).jpg")
                            
                            imagemRecuperada.downloadURL { (url, error) in
                                print("Link: \(url?.absoluteString)")
                                self.performSegue(withIdentifier:"SegueSelecionarUsuarios", sender: url?.absoluteString)
                            }
                            
                               
                           }else{
                            
                               let alerta = Alerta(titulo: "Upload fail", mensagem: "Error saving file, try again!")
                               self.present(alerta.getAlerta(), animated: true, completion: nil)
                               
                           }
                           
                       })
                       
                   }
        
               }

        }// Fim do método next
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == "SegueSelecionarUsuarios"{
            
            let usuarioViewController = segue.destination as! UsuariosTableViewController
            usuarioViewController.descricao = self.descricao.text!
            usuarioViewController.urlImagem = sender as! String
            usuarioViewController.idImagem = self.idImagem
        }
    }
    
    
    
    
    

}
