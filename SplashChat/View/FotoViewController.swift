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
    }
    
    
    @IBAction func albumFotos(_ sender: Any) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagem.image = imagemRecuperada
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cameraOpen(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        
               self.nextButton.isEnabled = false
               self.nextButton.setTitle("Loding...", for: .normal)
               
               let armazenamento = Storage.storage().reference()
               let imagens = armazenamento.child("imagens")
               
               //Recuperar a imagem
               if let imagemSelecionada = imagem.image  {
                   
                if let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.1) {
                       
                       imagens.child("\(self.idImagem).jpg").putData(imagemDados, metadata: nil, completion: { (metaDados, erro) in
                           
                           if erro == nil {
                               
                               print("Sucesso ao fazer o upload do Arquivo")
                               
                              // let url = metaDados?.downloadURL()?.absoluteString
                               //self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: url)
                               
                               self.nextButton.isEnabled = true
                               self.nextButton.setTitle("Next", for: .normal)
                               
                           }else{
                            
                            print("Erro ao fazer o upload do Arquivo")
                            

                              // let alerta = Alerta(titulo: "Upload falhou", mensagem: "Erro ao salvar o arquivo, tente novamente!")
                              // self.present(alerta.getAlerta(), animated: true, completion: nil)
                               
                           }
                           
                       })
                       
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

}
