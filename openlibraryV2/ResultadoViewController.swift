//
//  ResultadoViewController.swift
//  openlibraryV2
//
//  Created by Alejandro Veiga López on 8/5/16.
//  Copyright © 2016 Alejandro Veiga López. All rights reserved.
//

import UIKit

class ResultadoViewController: UIViewController {

    @IBOutlet weak var TituloLabel: UILabel!
    @IBOutlet weak var AutoresLabel: UILabel!
    @IBOutlet weak var PortadaImage: UIImageView!
    @IBOutlet weak var PortadaLabel: UILabel!

    
    var titulo: String = ""
    var autores: String = ""
    var Portada: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        TituloLabel.text = titulo
        AutoresLabel.text = autores
        
        if (Portada == nil) {
        
            self.PortadaLabel.hidden = false
        
        }
        else {
            
            self.PortadaLabel.hidden = true
            
            self.PortadaImage.image = Portada
/*
            let url = NSURL(string: urlPortada as String)
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                //make sure your image in this url does exist, otherwise unwrap in a if let check
                let data = NSData(contentsOfURL: url!)
                
                if (data != nil) {
                
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.PortadaImage.image = UIImage(data: data!)
                    
                    });
                    
                }
                else {
                    
                    self.PortadaLabel.hidden = false
                    self.PortadaLabel.text = "Error URL"
                }
 
            }
            
*/
        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
