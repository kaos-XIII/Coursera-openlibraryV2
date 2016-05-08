# openlibraryV2

Instrucciones

En este entregable desarrollarás una aplicación usando Xcode que realice una petición a https://openlibrary.org/ y que muestre el resultado en una tabla jerárquica a dos niveles En el primer nivel se encontrará una vista tabla, mostrando los títulos de libros ya buscados. Al momento de seleccionar uno de los renglones de la tabla, el detalle del libro deberá ser mostrado.

La idea es que los libros que se vayan buscando se vayan integrando la estructura que representará la fuente de datos de la vista tabla.

Puedes seleccionar, al momento de crear tu proyecto la plantilla Maestro-Detalle. De esta manera se facilita la codificación de tu aplicación

IMPORTANTE. AL momento de crear tu proyecto, no olvides seleccionar el uso de Core Data ya que se usará en ese módulo y así se facilitan las cosas

-----

1 Al iniciar la aplicación, una vista tabla deberá ser mostrada

2. Deberá contener un UIBarButtonItem, en específico el Add (signo +) en la barra de navegación que permita hacer una búsqueda y añadir el libro a la tabla

3. Al presionar el botón de añadir (punto anterior), se deberá mostrar una vista que permita ingresar el ISBN de un libro y mostrar, en caso de éxito de la búsqueda:

El título del libro
Los autores del libro
La portada (en caso de que se encuentre)
4. Al regresar a la vista tabla, el título del libro buscado deberá aparecer en la tabla

5. Si seleccionamos un renglón de la tabla que contenga un título de libro, deberá mostrar sus detalles
