object reserva {
    const animales = []
    const areas = []


    method todosLosDebiles() {
         animales.filter({a => a.esDebil()})
    }
    method areasEnEquilibrio() {
        areas.filter({a=>a.estaEnEquilibrio()})
    }
}

class Area {
    const animales = []
    var property valorComun = 50
    var property agua
    var property refugios
    
    method agregarAnimal(animal) {
        animales.add(animal)
    }
    method obtenerAgua() = agua
    method obtenerRefugios() = refugios
    method obtenerValorComun() = valorComun 
    method esHabitable() {
        return self.obtenerAgua() > 700 && (self.obtenerRefugios() > 200 && self.obtenerRefugios() < 300)
    }
    method elMasVigoroso(animal) {
        return animales.max({a=>a.energia()})

    }
    method sufreIncendio() {
        animales.forEach({a=>a.recibirAmenaza()})
        agua = agua * 0.9
    }
    method intervieneProfesional() {
        animales.forEach({a=>a.seRecupera(self)})
    }
    method consumirAgua(cantidad) {
        agua -= cantidad
    }
    method consumirRefugios(cantidad) {
        refugios -= cantidad
    }
    method estaEnEquilibrio() {
        return self.esHabitable() && animales.all({a=>a.estaSatisfecho(self)})
    }
}
class Animal {
    var property nivelAlerta = 20
    method esDebil(area) { return self.energia() < area.obtenerValorComun() }
    method obtenerNivelAlerta() = nivelAlerta
    method energia()
    method recibirAmenaza()
    method seRecupera(area) {} 
    method estaSatisfecho(area) { return
        area.obtenerAgua() > (self.energia() * 3) or self.esAcogedora(area)
    }
    method esAcogedora(area)
}

class Ciervo inherits Animal {
    override method energia() { 
        return if (self.obtenerNivelAlerta() <= 30) 300 else self.obtenerNivelAlerta() * 2
    } 
    override method recibirAmenaza() {
        nivelAlerta = nivelAlerta * 2
    }
    override method seRecupera(area) {
        area.consumirAgua(4)
        nivelAlerta += 20
    }
    override method esAcogedora(area) { return
        area.obtenerAgua() > 10
    }
    
}

class CiervoMontania inherits Ciervo {
    override method energia() { return super() + 15}
    override method seRecupera(area) {
        super(area)
        nivelAlerta += 1
    }
}

class Felino inherits Animal {
    var property peso
    var property ferocidad
    method obtenerPeso() = peso
    method obtenerFerocidad() = ferocidad
    override method energia() {
         return if (self.obtenerPeso() < 90 ) self.obtenerFerocidad() else self.obtenerFerocidad() * 0.5
    }
    override method recibirAmenaza() { 
        peso += 20
    }
    method afilarGarras() {
        peso =- 10
        ferocidad += 10
    }
    override method seRecupera(area) {
        area.consumirRefugios(8)
        peso += 15
        ferocidad += 15
    }
    override method esAcogedora(area) { 
        return area.animales().any({a => a.energia() > self.energia() }) }
}

class FelinoMancha inherits Felino {
    var property manchas
    method obtenerManchas() = manchas
    override method energia() { 
        return super() + self.obtenerManchas() * 2
    }
    override method recibirAmenaza() {
        super()
        manchas +=1
    }
    override method esAcogedora(area) {
        return area.obtenerRefugios() > self.obtenerManchas()
    }
}

class AveRapaz inherits Animal {
    var property alturaVuelo
    method obtenerAlturaVuelo() = alturaVuelo
    override method energia() {
        return self.obtenerAlturaVuelo() * 3
    }
    override method recibirAmenaza() {
        alturaVuelo += 50
    }
    method vueloReconocimiento() {
        alturaVuelo = 5
    }
    override method esAcogedora(area) {
        return false
    }
}
