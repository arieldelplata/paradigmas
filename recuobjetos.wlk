//Código reescrito

object servicioDeUptime { //BaseDeDatos ahora es una clase y no un objeto, asi que tendria que poner un new BDD, y no BDD a secas
  const serviciosRegistrados = [
    new ServicioWeb(url="http://localhost:8080")
  ]

  method registrarServicio(servicio) {
    serviciosRegistrados.add(servicio)
  }

   method serviciosNoDisponibles() { //uso de funcion filter en lugar de cadena de if's
    return serviciosRegistrados.filter({s => not s.estaDisponible()})
  }
}

class ServicioWeb {
    var property puerto = 8080
    var property url
    var estadoServicio = "ok"
    const rutas = []

    method initialize() { //listas entienden .add, diccionarios entienden .put
        rutas.add(rutaHola)
        rutas.add(rutaHealth)
    }
    method estadoActual() = estadoServicio
    
    method estaDisponible() {
        return self.llamarServicio("/health") == "ok"

    }

    method llamarServicio(ruta) { //uso find en lugar de filter. Necesito que devuelva el objeto, y no una lista con el objeto adentro (filter).
        return rutas.findOrElse({ r => r.puedoAtender(ruta) }, {rutaNoEncontrada}).ejecutar(self) //Busca encuentra y retorna el objeto de un saque y da bloque de error si falla.
    }

//methods para wtest
    method caer() { estadoServicio = "error"}
    method levantar() { estadoServicio = "ok"}
}

class BaseDeDatos {
    var property puerto = 5432
    const datosAlmacenados = []
  
  //agrego method estaDisponible para mantener polimorfismo
  //una bdd esta disponible si tiene datos almacenados, entonces eso se modula aqui dentro y no hace falta otro method de cantdedatosalmacenados
    method estaDisponible() {
        return not datosAlmacenados.isEmpty() //o return datosAlmacenados.size() > 0
    }

    method llamarServicio(ruta) {

    }

    method agregarDato(dato) {
        datosAlmacenados.add(dato)
    }

    method obtenerPuerto() = puerto

    method setearPuerto(nuevoPuerto) {
        puerto = nuevoPuerto
    }
}

class ServicioOffice {
    var property claveConfigurada = ""
    const clavesValidas = ["FreeTrial", "Student", "Premium"]

    method estaDisponible() {
        return clavesValidas.contains(claveConfigurada)
    }

}

object rutaHola {
    method puedoAtender(r) = r == "/holamundo"
    method ejecutar(s) {
        return s.estadoActual()
    }
}

object rutaHealth {
    method puedoAtender(r) = r == "/health"
    method ejecutar(s) {
        return s.estadoActual()
    }

}

object rutaNoEncontrada {
    method puedoAtender(r) = true
    method ejecutar(s) {
        return "ruta no encontrada"
    }
}
