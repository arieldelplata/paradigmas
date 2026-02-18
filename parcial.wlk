
object servicioDeUptime {
  const serviciosRegistrados = [
    new ServicioWeb(url="http://localhost:8080"),
    baseDeDatos
  ]

  method registrarServicio(servicio) {
    serviciosRegistrados.add(servicio)
  }

  method obtenerEstadoDeServicio(tipoServicio) {
    if (tipoServicio == "web") { //uso de if para consultar un tipo. Solucion: Delegar
      const servicioWeb = serviciosRegistrados.find({s => s.tipoServicio() == "web"})//igual
      return servicioWeb.llamarServicio("/health") //uso de flag. Solución: Delegar
    } else if (tipoServicio == "base de datos") {
      const servicioBaseDeDatos = serviciosRegistrados.find({s => s.tipoServicio() == "base de datos"})//igual
      return servicioBaseDeDatos.cantidadDeDatosAlmacenados() > 0
    } else {
      return "ruta no encontrada"
    }
  }
}

class ServicioWeb { 
  var tipoServicio = "web"
  var property puerto = 8080
  var property url
  var property estadoServicio = "ok"

  method setearTipoServicio(tipo) {
    tipoServicio = tipo
  }

  method obtenerTipoServicio() = tipoServicio

  method llamarServicio(ruta) {
    if (ruta == "/holamundo") {
      return "hola mundo"
    } else if (ruta == "/health") {
      return estadoServicio
    } else {
      return "ruta no encontrada"
    }
  }
}

object baseDeDatos { //inconsistencia en modelado de clases. Tenemos dos tipos de servicios, donde uno es una clase y otro un objeto. Solucion: 2 clases 
  var puerto = 5432
  var property tipoServicio = "base de datos"
  var property datosAlmacenados = []

  method agregarDato(dato) {
    datosAlmacenados.add(dato)
  }
  method cantidadDeDatosAlmacenados() = datosAlmacenados.size()

  method obtenerTipoServicio() = tipoServicio

  method obtenerPuerto() = puerto 

  method setearPuerto(nuevoPuerto) {
    puerto = nuevoPuerto
  }
}