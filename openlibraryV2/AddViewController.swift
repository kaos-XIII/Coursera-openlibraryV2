//
//  AddViewController.swift
//  openlibraryV2
//
//  Created by Alejandro Veiga López on 8/5/16.
//  Copyright © 2016 Alejandro Veiga López. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var SearchText: UITextField!
    @IBOutlet weak var TituloText: UITextField!
    @IBOutlet weak var AutoresText: UITextField!
    @IBOutlet weak var PortadaImage: UIImageView!
    @IBOutlet weak var OcultaPortadaLabel: UILabel!
    @IBOutlet weak var AnadirButton: UIButton!
    
    var resultadoTitulo: String? = nil
    var resultadoAutores: String? = nil
    var resultadoPortada: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.OcultaPortadaLabel.hidden = false
        self.SearchText.delegate = self
        self.AnadirButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ClearAcction() {
        
        //self.SearchText.text = ""
        self.TituloText.text = ""
        self.AutoresText.text = ""
        self.OcultaPortadaLabel.hidden = false

    }
    
    //
    //Esconde teclado si tocas pantalla.
    //
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        super.touchesBegan(touches, withEvent: event)
        view.endEditing(true);
        
    }
    
    //
    // Presionas "ENTER" se esconde el teclado. (Por metodo de Delegacion)
    // Mirar que en la clase ViewControler tiene UITextFieldDelegate
    // Cada caja de Texto tiene que tener el delegate del viewController
    //
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        buscar()
        
        textField.resignFirstResponder();
        return false;
        
    }

    func buscar(){
        
        if (self.SearchText.text != nil && self.SearchText.text != "") {
            
            self.OcultaPortadaLabel.hidden = false
            
            let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
            
            let url = NSURL(string:urls + self.SearchText.text!)
            
            let datos:NSData? = NSData(contentsOfURL: url!)
            
            if (datos != nil) {
                
                let resultado = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                
                if (resultado != "{}") {
                    
                    do {
                        
                        let jsonCrudo = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                        
                        let jsonDic = jsonCrudo as! NSDictionary
                        
                        let isbnDic = jsonDic["ISBN:\(self.SearchText.text!)"] as! NSDictionary
                        
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        if (isbnDic["title"] != nil) {
                            
                            let title = isbnDic["title"] as! NSString as String
                            
                            TituloText.text = title
                            
                            resultadoTitulo = title
                            
                        }
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        if (isbnDic["authors"] != nil) {
                            
                            let authorsArray = isbnDic["authors"] as! NSArray
                            
                            var authors = "None"
                            
                            for i in 0...authorsArray.count-1 {
                                
                                if (i == 0) {
                                    
                                    authors = ("\(authorsArray[i]["name"]! as! NSString as String)")
                                    
                                }
                                else {
                                    
                                    authors += (", \(authorsArray[i]["name"]! as! NSString as String)")
                                    
                                }
                                
                            }
                            
                            AutoresText.text = authors as String
                            
                            resultadoAutores = authors as String
                            
                        }
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        // De manera Asincrona
                        if (isbnDic["cover"] != nil) {
                            
                            let coverDic = isbnDic["cover"] as! NSDictionary
                            
                            if (coverDic["large"] != nil) {
                                
                                self.OcultaPortadaLabel.hidden = true
                                
                                let urlcoverL = coverDic["large"] as! NSString as String
                                
                                resultadoPortada = urlcoverL as String
                                
                                let url = NSURL(string: urlcoverL)
                                
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                                    
                                    //make sure your image in this url does exist, otherwise unwrap in a if let check
                                    let data = NSData(contentsOfURL: url!)
                                    
                                    if (data != nil) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), {
                                            
                                            self.PortadaImage.image = UIImage(data: data!)
                                            
                                        });
                                        
                                    }
                                    else {
                                        
                                        self.OcultaPortadaLabel.hidden = false
                                        self.OcultaPortadaLabel.text = "Error URL"
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////////////////////////////////////
                        
                        self.AnadirButton.enabled = true
                        
                    }
                    catch _ {
                        
                        ClearAcction()
                        
                        let titulo = "Not Found"
                        let mensaje = "Error JSON"
                        let boton = "Ok"
                        
                        let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: boton, style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                    }
                    
                }
                else {
                    
                    ClearAcction()
                    
                    let titulo = "Not Found"
                    let mensaje = "ISBN not found in https://openlibrary.org/"
                    let boton = "Ok"
                    
                    let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: boton, style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
            }
            else {
                
                ClearAcction()
                
                let titulo = "Connection Error"
                let mensaje = "Connection Error"
                let boton = "Ok"
                
                let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: boton, style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
        }
        else {
            
            ClearAcction()
            
            let titulo = "Not Found"
            let mensaje = "You need an ISBN"
            let boton = "Ok"
            
            let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: boton, style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }// End if
        
    }
    
    
// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }

    @IBAction func AnadirAcction(sender: UIButton) {
        
        print("Añadir Libro")
        
        self.performSegueWithIdentifier("anadirLibroSegue", sender: self)
    
    }

}
