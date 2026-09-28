
//NO SE COMO CONECTAR EL RECIBIR AMENAZAS DEL PADRE CON EL RESTO DE LAS NAVES

class NavesEspaciales{

  var velocidad 
  var direccion
  var combustible  

  method velocidad() = velocidad
  method direccion() = (direccion.max(-10)).min(10)

  method acelerar(cuanto) {
      velocidad = cuanto.max(100000)
  }

  method deacelerar(cuanto) {
    velocidad == cuanto.min(0)
  }

  method irHaciaElSol() {
    direccion == 10
  }

  method escaparDelSol() {
    direccion == -10
  }

  method ponerseParaleloAlSol() {
    direccion == 0
  }

  method acercarseUnPocoAlSol() {
    direccion += 1
    
  }

  method alejarseUnPocoAlSol() {
    direccion -= 1
    
  }

  method cargarCombustible(litros) {
    combustible += litros
  }
  method descargarCombustible(litros) {
    combustible -= litros
  }

  method estaTranquila() = combustible == 4000 && velocidad == 12000

  method recibirAmenazas() = true

  method estaDeRelajo() = self.recibirAmenazas() 


}

class NavesBaliza inherits NavesEspaciales {
  
  var baliza = "azul"
  var balizaCambiada = 0


  method baliza() = baliza

  method cambiarColorDeBaliza(colorNuevo) {
      baliza = colorNuevo
      balizaCambiada += 1
  }

  method prepararViaje(){
    self.cambiarColorDeBaliza("verde")
    NavesEspaciales.ponerseParaleloAlSol()
    NavesEspaciales.cargarCombustible(30000)
    NavesEspaciales.acelerar(5000)
  }

  override method estaTranquila() = super() && self.baliza() != "rojo"

  method escapar() {
    NavesEspaciales.acercarseUnPocoAlSol()
  }
  
  method avisar() {
    self.cambiarColorDeBaliza("rojo")
  }

  override method estaDeRelajo() = super() && balizaCambiada == 0

}

class NavesPasajeros inherits NavesEspaciales{

  var cantPasajeros
  var racionComida
  var racionBebida

  var racionComidaServida = 0

  method cantPasajeros() = cantPasajeros
  method racionBebida() = racionBebida
  method racionComida() = racionComida

  method cargarRacionDe(racionDe, cant) {
    if(racionDe == racionComida){
      racionComida += cant
      racionComidaServida += cant
    }
    else if(racionDe == racionBebida){
      racionBebida += cant
    }
  }

  method descargarRacionDe(racionDe, cant) {
    if(racionDe == racionComida){
      racionComida -= cant
    }
    else if(racionDe == racionBebida){
      racionBebida -= cant
    }
  }

  

  method prepararViaje() {
    cantPasajeros.times({ i => self.cargarRacionDe(racionComida, 4) })
    cantPasajeros.times({ i => self.cargarRacionDe(racionBebida, 6) })
    NavesEspaciales.acercarseUnPocoAlSol()
    NavesEspaciales.cargarCombustible(30000)
    NavesEspaciales.acelerar(5000)
  }

  method escapar() {
    
  }
  method avisar() {
    cantPasajeros.times({ i => self.descargarRacionDe(racionComida, 1) })
    cantPasajeros.times({ i => self.descargarRacionDe(racionBebida, 2) })
  }

   override method estaDeRelajo() = super() && racionComidaServida < 50

}

class NavesCombate inherits NavesEspaciales{

  var invisible = true

  method estaInvisible() = invisible
  method ponerseInvisible() {
    invisible = true
  }
  method ponerseVisible() {
    invisible = false
  }

  var misilesDesplegado = true

  method misilesDesplegados() = misilesDesplegado
  method replegarMisiles() {
    misilesDesplegado = false
  }
  method deplegarMisiles() {
    misilesDesplegado = true
  }

  var mensajeEmitidos = []

  method mensajeEmitidos() = mensajeEmitidos
  method primerMensajeEmitido() = mensajeEmitidos.first()
  method ultimoMensajeEmitido() = mensajeEmitidos.last()

  method emitirMensaje(mensaje) = mensajeEmitidos.add(mensaje)
  method emitioMensaje(mensaje) = mensajeEmitidos.any(mensaje)
  method esEscueta() = mensajeEmitidos.any({n => n.length() == 30})

  method prepararViaje() {
    self.ponerseInvisible()
    self.replegarMisiles()
    NavesEspaciales.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
    NavesEspaciales.cargarCombustible(30000)
    NavesEspaciales.acelerar(5000)
  }

  override method estaTranquila() = super() && self.misilesDesplegados() == false


  method escapar() {
    NavesEspaciales.acercarseUnPocoAlSol()
    NavesEspaciales.acercarseUnPocoAlSol()
  }
  method avisar() {
    self.emitirMensaje("Amenaza recibida")
  }

}


class NaveHospital inherits NavesPasajeros {
  
  var quirofanoPreparado = true
  
  method quirofanoPreparado() = quirofanoPreparado
  method cambiarEstadoDeQuirofano() {
    quirofanoPreparado = !quirofanoPreparado
  }

  override method estaTranquila() = super() && self.quirofanoPreparado() == false

  


}

class NaveCombateSigilosa inherits NavesCombate {
  
  override method estaTranquila() = super() && NavesCombate.estaInvisible() == false

  override method escapar() {
    super();
    NavesCombate.deplegarMisiles()
    NavesCombate.ponerseInvisible()
  }

}