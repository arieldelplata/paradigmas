//Explosion de Clases. Debo abstraer en: Que es -> Falda, Blusa, Short
//y Que tiene? -> Tela. Por lo tanto, falda, blusa, short deben ser clases,
//y el tipo de tela un atributo. Si no, si quiero agregra una nueva tela,
//tengo que crear tres nuevas clases x tipo de tela.afilarGarras
//Uso de COMPOSICION y HERENCIA (1)c))

//Mal uso de Poliformismo. (1)a))
//El pedido tiene listas separadas para cada tipo de prenda. Si en un futuro
//quiero agregar una nueva prenda, tengo que modificar el codigo. Si todas
//las prendas entendieran el mismo mensaje y estuvieran unificadas en una
//unica lista de "prendas", x ej, en Class Pedido se llama a prenda.tiempo().

//Logica repetida en telas. (1)b))
//Varios tipos de Blusa, x ejemplo, comparten logica. Implemento una clase
//u objeto Blusa, Short y Falda, acompañando logica anerior de Polimorfismo

//Mala declaratividad. Uso de foreach y variables internas, acumuladores manuales, reemplazables
//por funciones de orden superior (1)d))


//CODIGO SOLUCION

class Pedido {
    const property prendas = []
    method tiempoDeConfeccion() {
        return prendas.sum({p=>p.tiempo()})
    }
    method agregarPrenda(prenda) {
        prendas.add(prenda)
    }
}

class Prenda {
    const tela
    method tiempo() { 
        return tela.tiempoFinal(self.tiempoBase())
    
    }
    method tiempoBase()
    
}

class Falda inherits Prenda {
    override method tiempoBase() {
        return 12
    }

}

class Blusa inherits Prenda {
    const cantBotones
    override method tiempoBase() {
        return 200 + cantBotones * 5
    }

}

class Short inherits Prenda {
    override method tiempoBase() {}
}

object lycra {
    method tiempoFinal(tiempoBase) {
        return tiempoBase * 1.2
    }
}

object denim {
    method tiempoFinal(tiempoBase) {
        return tiempoBase + 25
    }

}

object modal {
    method tiempoFinal(tiempoBase) {
        return tiempoBase
    }
}

