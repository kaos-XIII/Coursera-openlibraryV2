//
//  PrincipalTablaViewController.swift
//  openlibraryV2
//
//  Created by Alejandro Veiga López on 8/5/16.
//  Copyright © 2016 Alejandro Veiga López. All rights reserved.
//
/*
 
 En este entregable desarrollarás una aplicación usando Xcode que realice una petición a https://openlibrary.org/ y que muestre el resultado en una tabla jerárquica a dos niveles En el primer nivel se encontrará una vista tabla, mostrando los títulos de libros ya buscados. Al momento de seleccionar uno de los renglones de la tabla, el detalle del libro deberá ser mostrado.
 
 La idea es que los libros que se vayan buscando se vayan integrando la estructura que representará la fuente de datos de la vista tabla.
 
 Puedes seleccionar, al momento de crear tu proyecto la plantilla Maestro-Detalle. De esta manera se facilita la codificación de tu aplicación
 
 IMPORTANTE. AL momento de crear tu proyecto, no olvides seleccionar el uso de Core Data ya que se usará en ese módulo y así se facilitan las cosas
  
 */

import UIKit
import CoreData

class Libro {
 
    var isbn: String
    var titulo: String
    var autores: String
    //var portada: String
    var portada: UIImage
    
    init(isbn: String, titulo: String, autores: String, portada: UIImage) {
    
        self.isbn = isbn
        self.titulo = titulo
        self.autores = autores
        self.portada = portada
    
    }
    
}

class PrincipalTablaViewController: UITableViewController {

    var tablaLibros = [Libro]()
    
    var contexto : NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = "Reslustados de Busquedas"
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let secionEntidad = NSEntityDescription.entityForName("Libros", inManagedObjectContext: self.contexto!)
        let peticion = secionEntidad?.managedObjectModel.fetchRequestTemplateForName("petLibros")
        
        do {
            
            let librosEntidad = try self.contexto?.executeFetchRequest(peticion!)
            
            for libro in librosEntidad! {
                
                let nuevoLibro = Libro(isbn: libro.valueForKey("isbn") as! String, titulo: libro.valueForKey("titulo") as! String, autores: libro.valueForKey("autores") as! String, portada: UIImage(data: libro.valueForKey("portada") as! NSData)! )
                
                tablaLibros.append(nuevoLibro)
                
            }
            
        }
        catch {
            
            print("ERROR...")
            
        }
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
       
        self.tableView.reloadData()
        
    }
    
// MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tablaLibros.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)

        // Configure the cell...

        cell.textLabel?.text = tablaLibros[indexPath.row].titulo
        
        return cell
    
    }
 

 /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "AddSegue" {
            
            //let dest = segue.destinationViewController as? AddViewController
            //dest!.delegate = self
            //print("Ir a Añadir")
            
        }
        else if segue.identifier == "ResultadoSegue" {
            
            let dest = segue.destinationViewController as? ResultadoViewController
            //dest!.delegate = self
            //print("Ir a Resultados")
            
            let libro: Libro!
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
            
                //let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                libro = self.tablaLibros[indexPath.row]
            
            }
            /*else if let mismoLibro = sender {
                
                libro = mismoLibro as! Libro
            
            }*/
            else {
            
                libro = self.tablaLibros.last
            
            }

            dest?.titulo = libro.titulo
            dest?.autores = libro.autores
            dest?.Portada = libro.portada
            
        }
        
    }
    
    
// MARK: - Añadir Libro
    
    @IBAction func anadirLibro (segue : UIStoryboardSegue) {

        //print("Añadir Libros a la Table View")
        
        if let origen = segue.sourceViewController as? AddViewController {
        
            if (origen.resultadoPortada == nil) {
                
                origen.resultadoPortada = UIImage.init(named: "portadaBlack")
            
            }
            
            let nuevoLibro = Libro(isbn: origen.resultadoISBN!, titulo: origen.resultadoTitulo!, autores: origen.resultadoAutores!, portada: origen.resultadoPortada!)
            
            tablaLibros.append(nuevoLibro)
            self.tableView.reloadData()
            
            let nuevaSeccion = NSEntityDescription.insertNewObjectForEntityForName("Libros", inManagedObjectContext: self.contexto!)
            
            nuevaSeccion.setValue(origen.resultadoISBN!, forKey: "isbn")
            nuevaSeccion.setValue(origen.resultadoTitulo!, forKey: "titulo")
            nuevaSeccion.setValue(origen.resultadoAutores!, forKey: "autores")
            nuevaSeccion.setValue(UIImagePNGRepresentation(origen.resultadoPortada!), forKey: "portada")
            
            do {
                
                try self.contexto?.save()
            
            }
            catch {
            
                print("Error en guardar en CORE DATA")
                
            }
            
        }
        
    }
    
}
