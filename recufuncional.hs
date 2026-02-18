--Red de sensores de temperatura. C/sensor emite lecturas continuamente.
--(Potencialmente infinitas, asumo que no se apagan)

--DESARROLLAR UN SISTEMA QUE PERMITA PROCESAR LAS LECTURAS DE ESTOS 
--SENSORES Y PODER CLASIFICARLAS DE ACUERDO A DISTINTOS CRITERIOS

--Una lectura de un sensor consta de los siguientes valores
--Tiempo: el instante en el que se realizo la lectura
--Temperatura: el valor de la temperatura medida (Kelvin)
--Estado: el estado del sensor al momento de realizar la lectura
data Estado = OK | Alerta Float | Desconectado deriving (Show, Eq)
--DEFINIR EL TIPO DE LECTURA, con Record Syntax
data Lectura = unaLectura {
    fecha :: Int,
    temperatura :: Float,
    estado :: Estado
} deriving (Show, Eq)

--CRITERIOS DE CLASIFICACION DE LECTURAS
paresDeLecturas :: [Lectura] -> [(Lectura, Lectura)]
paresDeLecturas lista = zip lista (tail lista) 
--ESTO INGRESA UNA LISTA Y DEVUELVE UNA TUPLA. compara con elemento anterior

--ESTABLE: TODAS LAS LECTURAS DE LA SERIE SON DE ESTADO OK Y LA VARIACION
--ENTRE UNA LECTURA Y LA SIGUIENTE ES MENORA 3 KELVIN
estaOk :: Lectura -> Bool
estaOk lectura = estado lectura == OK

pocaVariacion :: (Lectura, Lectura) -> Bool
pocaVariacion (l1, l2) = abs (temperatura l1 - temperatura l2) < 3
--abs es la funcion de valor absoluto. Se usa xq no importa si la temp
--subio o bajo, solo importa la magnitud del cambio
esEstable :: [Lectura] -> Bool
esEstable lecturas = all estaOK lecturas && all pocaVariacion (paresDeLecturas lecturas)
--No se puede usar lambda porque estaOk revisa una lectura y pocaVariacion un par de lecturas
--ALERTA: EXISTE AL MENOS UNA LECTURA DEL ESTADO ALERTA CON UN VALOR MAYOR
--A 40 KELVIN
unaAlerta :: Estado -> Bool
unaAlerta (Alerta _) = True
unaAlerta _ = False

esAlerta :: [Lectura] -> Bool
esAlerta lecturas = any (\l -> unaAlerta (estado l) && temperatura l > 40) lecturas

--APAGADO: TODAS LAS LECTURAS DE LA SERIE ESTAN EN ESTADO DESCONECTADO
esApagado :: [Lectura] -> Bool
esApagado lecturas = all(\l -> estado l == Desconectado) lecturas


--CONVERTIR TODAS LAS TEMPERATURAS DE UNA SERIE DE LECTURAS A FARENHEIT
aFarenheit :: Lectura -> Lectura
aFarenheit lectura = lectura {temperatura = (temperatura lectura * 1.8) + 32}

todasAFarenheit :: [Lectura] -> [Lectura]
todasAFarenheit lecturas = map aFarenheit lecturas   

--EL SISTEMA A VECES EMITE LECTURAS ERRONEAS. Lecturas erroneas tienen
--temperatura menor a 0 grados y desconectado. Realizar funcion
--arreglarLecturas que dada una serie cambie la temperatura a un valor
--promedio 25 kelvin y el estado a OK para todas las que sean erroneas.
--Usar composicion y orden superior
verificaError :: Lectura -> Bool
verificaError lectura = temperatura lectura < 0 && estado lectura == Desconectado

arreglarLectura :: Lectura -> Lectura
arreglarLectura lectura 
    | verificaError lectura = lectura {temperatura = 25, estado = OK}
    | otherwise = lectura
arreglarLecturas :: [Lectura] -> [Lectura]
arreglarLecturas lecturas = map arreglarLectura lecturas

--QUE SUCEDE CON LAS FUNCIONES DEFINIDAS EN LOS PUNTOS 
--ANTERIORES SI LA LISTA DE LECTURAS ES INFINITA?

--arreglarLecturas -> Devuelve una lista infinita que va evaluando a 
--medida que se necesita
--todasAFarenheit -> Lo mismo

--esEstable -> (all) Si todas las lecturas estan bien, sigue buscando infinitamente (DIVERGE)
--cuando encuentra un error, falla y devuelve false
--esApagado -> Lo mismo
--esAlerta -> (any) Si no encuentra ningun error, sigue buscando infinitamente
--cuando encuentra una que cumple la condicion, falla y devuelve true
