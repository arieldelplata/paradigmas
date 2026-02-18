--HASKELL HACE COMP DE FUNCIONES Y FLUJO DE DATOS DE DER A IZQ
--funcion x y lista = (filter (> x) . map (\f -> f y)) lista
--Esto es una composicion de funciones (x.y) aplicado a una lista


--filter (> x) . Paso funcion (>x) como parametro. (ORDEN SUPERIOR) 
x :: [b] -> [b] --toma la lista b que salio del map de la funcion y. La salida de una funcion es la entrada de otra. (COMPOSICION)
x > x

--compara cada elemento de la lista de tipo b con x
--para realizar una comparacion, como > o <, b tiene que ser ordenable, osea de tipo Ord (TYPE CLASS: Ord)
--entonces, x tiene que ser del mismo tipo que b



--map (\f -> f y)
y :: [a -> b] -> [b]
y lista = map (\f -> f y) lista
--y se aplica a cada funcion f de la lista
--identifico tipo de funcion y como -> a
--entonces, cada funcion de f va de a hacia algo. digamos (a->b)
--lista de entrada [a -> b]


--funcion del ejercicio con declaracion 
funcion :: Ord b => b -> a -> [a -> b] -> [b]
--(b es tipo Ord) -> tipo de x -> tipo de y -> [lista de valores a y b] -> [lista de valores b]
funcion x y lista = (filter (> x) . map (\f -> f y)) lista


--Realizar mejoras en terminos de EXPRESIVIDAD
--x y no expresan explicitamente con que se está operando. es mejor reemplazar
--x por "limite" e y por "valor"
--lo mismo el nombre "funcion", reemplazo por "valoresMayoresA"
--Lambda en funcion valor --> Reemplazo por operador $ que significa "aplico este valor a la funcion entrante"

valoresMayoresA :: Ord b => b -> a -> [a -> b] -> [b]
valoresMayoresA limite valor = filter (> limite) . map ($ valor)

--Seria posible evaluar la funcion con una lista infinita de modo que
--dicha evaluacion termine --> Si.

--En HS las listas no se construyen enteras en memoria, Son estructuras potenciales
--que se calculan bajo demanda
--La funcion map no transformara la lista infinita de golpe, ira generando
--los resultados uno a uno a medida que se necesiten
--Haskell es perezoso, recordar concepto
--La funcion filter ira pidiendo esos resultados uno a uno y descasrtando o aprobando
--Para que la evaluacion termine, necesitamos limitar la salida usando
--una funcion que corte el flujo como TAKE o HEAD. Si intentamos imprimir
--la lista completa no terminara nunca porque es infinita
--EJEMPLO
funcionesInfinitas :: [Int -> Int]
funcionesInfinitas = map (+) [1..]
--el [1..] genera una lista infinita de numeros a partir del 1
ejemploQueTermine :: [Int]
ejemploQueTermina = take 1 (valoresMayoresA 10 5 funcionesInfinitas)
--toma 1 de la lista de funcionesInfinitas, le aplica el numero 5. Llama a 
--valoresMayoresA que tiene el filter, el filter (>10) le pide al map
--el primer resultado procesado (1 + 5) = 6.
--el filter pregunta (6 > 10?) -> NO, lo descarta y pasa al siguiente valor.


--IMPORTANTE
--ejemploQueTermina = take 1 (valoresMayoresA 10 5 funcionesInfinitas)
--TAKE es la funcion que "Manda", que decide cuando parar
--Los datos vienen de la derecha. Primero, se aplica la funcion mas 
--cercana a los datos(lista). Der a izq

--RTA FINAL
----Seria posible evaluar la funcion con una lista infinita de modo que
--dicha evaluacion termine?

--SI. Esto es posible gracias a la Lazy Evaluation de HS,
--Las expresiones no se evaluan hasta que un resultado es estrictamente 
--necesario. Una lista infinita no se genera completa en memoria, si no que
--crea un PROMISE. Ademas, las funciones map y filter son func de orden
--superior tambien lazy, ya que map no transforma toda la lista infinita
--de entrada, solo el que se le pide, y filter pide elementos al map, los
--evalua y descarta o aprueba uno a uno.
--Si usamos TAKE, el proceso se detiene justo despues de obtener los resultados
--descartando el resto de la lista.

funcion :: Ord b => b -> a -> [a -> b] -> [b]
funcion 3 "hola" []
--ES VALIDA? -> SI 
--3 -> Limite
-- "hola" = string -> valor es string
--lista = [] lista vacia
--LA LISTA VACIA DE HS ES POLIMORFICA. Puede disfrazarse de lo que necesite
--la funcion, osea, aca actua como lista de func [String -> Int]
--Devuelve una lista vacia de enteros []

funcion 3 7
--SI ES VALIDA
--3 -> Limite
--7 -> valor 
--falta el tercer argumento, la lista. Entonces, al funcion ser una funcion
--que espera 3 argumentos, pero esta recibiendo 2, esto devuelve una funcion
-- [Int -> Int] -> [Int], que es una funcion que espera una lista
-- de operaciones numericas y devolvera la lista filtrada

funcion "chau" "hola" [length]
--"chau" -> Limite
--"hola" -> valor
--lista [length] toma un String y devuelve un Int
--Filter va a comparar Int > String, que es un type mismatch
--NO ES VALIDA