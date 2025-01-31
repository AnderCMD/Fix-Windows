# Fix-Windows

_Este proyecto contiene un script automatizado en batch que comprueba la integridad de los archivos del sistema de Windows y los repara si es necesario. Utiliza herramientas integradas de Windows para verificar y reparar archivos corruptos o faltantes en el sistema._

## Comenzando 🚀

_Estas instrucciones te permitirán obtener una copia del proyecto en funcionamiento en tu máquina local para propósitos de desarrollo y pruebas._

### Pre-requisitos 📋

Para ejecutar este proyecto en tu máquina, necesitas tener un sistema operativo Windows y acceso a la terminal de PowerShell o el Símbolo del sistema.

### Instalación 🔧

1. Clona el repositorio
    ```
    git clone https://github.com/AnderCMD/Fix-Windows.git
    ```

2. Navega al directorio del proyecto
    ```
    cd Fix-Windows
    ```

3. Ejecuta el script
    ```
    fix-windows.bat
    ```

El script se ejecutará y comprobará la integridad de los archivos del sistema de Windows. Si se encuentran problemas, automáticamente intentará repararlos.

## Ejecutando el script ⚙️

El script realiza los siguientes pasos:

1. Ejecuta la herramienta `sfc /scannow` para comprobar la integridad de los archivos del sistema.
2. Si se encuentran problemas, intentará repararlos automáticamente.
3. En caso de que `sfc` no pueda solucionar los problemas, el script ejecutará `DISM` para realizar una reparación más profunda.

## Despliegue 📦

Este proyecto no requiere despliegue, ya que el script está diseñado para ser ejecutado localmente en una máquina con Windows.

## Construido con 🛠️

* [Batch](https://ss64.com/nt/) - Lenguaje de secuencias de comandos utilizado para automatizar el proceso

## Contribuyendo 🖇️

Este proyecto ha sido realizado por mí. Si tienes alguna sugerencia o mejora, no dudes en abrir un **pull request**.

## Autores ✒️

* **Ander González** - *Ingeniero en Software* - [AnderCMD](https://github.com/AnderCMD)

## Licencia 📄

Este proyecto está bajo la Licencia MIT - mira el archivo [LICENSE.md](LICENSE.md) para detalles.

---
⌨️ con ❤️ por [AnderCMD](https://github.com/AnderCMD) 😊
