# Fix Windows

Script automatizado que comprueba la integridad de los archivos del sistema de Windows y los repara si es necesario

## Comenzando 🚀

Estas instrucciones te permitirán obtener una copia del proyecto en funcionamiento en tu máquina local para propósitos de desarrollo o uso.

## Pre-requisitos 📋

Que cosas necesitas para instalar el software y como instalarlas

```
Terminal / CMD
Ejecutar como Administrador el archivo FixWindows.bat
```
## Scripts ⚙️

Scripts que usa y su funcionalidad:

```
sfc /scannow: Escanea y repara archivos dañados o faltantes del sistema operativo.
```
```
DISM /Online /Cleanup-Image /CheckHealth: Verifica si la imagen del sistema tiene corrupción de forma rápida.
```
```
DISM /Online /Cleanup-Image /ScanHealth: Realiza un análisis detallado para detectar problemas en la imagen del sistema.
```
```
DISM /Online /Cleanup-Image /RestoreHealth: Repara la imagen del sistema operativo si está dañada.
```

## Construido con 🛠️

Herramientas utilizadas:

* [Batch](https://es.wikipedia.org/wiki/Archivo_batch#:~:text=En%20DOS%2C%20OS/2%20y,cmd.)

## Autores ✒️

_Menciona a todos aquellos que ayudaron a levantar el proyecto desde sus inicios_

* **Ander González González** - *Ingeniero en Software* - [AnderCMD](https://github.com/AnderCMD)
## Licencia 📄

Este proyecto está bajo la Licencia (MIT License) - mira el archivo [LICENSE.md](LICENSE.md) para detalles

---
⌨️ con ❤️ por [AnderCMD](https://github.com/AnderCMD) 😊
