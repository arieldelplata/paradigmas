primario(rojo).
primario(azul).
primario(amarillo).

%representar mezclas
%mezclar(primario, primario, secundario)

%mezclar rojo y azul da violeta
mezclar(rojo, azul, violeta).
mezclar(azul, rojo, violeta).

%mezclar amarillo y azul da verde
mezclar(amarillo, azul, verde).
mezclar(azul, amarillo, verde).

%mezclar rojo y amarillo da naranja
mezclar(rojo, amarillo, naranja).
mezclar(amarillo, rojo, naranja).

%reglas. "Esto es verdad SI pasa esto otro"
%el simbolo del "SI" es el :-
%"un color es secundario si existen 2 colores
%primarios distintos que al mezclarlos dan ese color"
secundario(Color) :-
    primario(Uno),
    primario(Otro),
    Uno \= Otro,
    mezclar(Uno, Otro, Color).
%basicamente entra a la regla, Color vale Violeta
%primario(Uno) -> Busca en mi BDD. Encuentra rojo, Uno = rojo
%primario(Otro) -> Busca en mi BDD. Encuentra azul, Otro = azul
%mezclar(rojo, azul, violeta) Busca en mis hechos de mezclas
%Existe? SI -> Devuelve true (osea, es secundario)

%Es inversible -> SI, porque su argumento "Color" permite
%tanto instanciacion (input) como variable libre (output)
%secundario(rojo) -> Instanciacion
%secundario(X) -> Variable libre
