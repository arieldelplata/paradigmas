%stock(sucursal, producto, cantidad)

stock(zarate, sillon(comun, 3), 4)
stock(zarate, silla(madera), 12)
stock(campana, sillon(cama, 2), 1)
stock(pilar, silla(metal), 4)
stock(escobar, sillon(reclinable, 2), 3)
stock(escobar(silla(madera), 8))
stock(campana, mesa(circular, vidrio), 1)
stock(campana, sillon(reclinable, 1) , 1)



%clientes
busca(mati, mesa(circular, vidrio), 1)
busca(mati, silla(metal), 4)
busca(leo, sillon(cama, 2), 1)
busca(leo, sillon(reclinable, 1), 1)

%trabaja(sucursal, material)
%materialproducto(producto, material)
materialproducto(mesa(_, vidrio), vidrio) %ignoramos primer dato (forma), solo queremos el material
materialproducto(silla(metal), metal)
%el el stock, no se declara el material de los sillones,
%pero la consigna dice "Todos los sillones son de madera"
%entonces, ignoramos ambos datos
materialproducto(sillon(_,_), madera)

trabaja(sucursal, material) :-
    stock(sucursal, producto, _),
    materialproducto(producto, material)

%sucursal ideal para el cliente. es ideal si tiene en stock TODO lo que busca el cliente
% TODO -> CUANTIFICACOR UNIVERSAL (forall)
% forall(condicion, prueba) "Para todas las soluciones de la Condicion, se debe cumplir la Prueba"
% si falla UNA sola vez, el forall entero devuelve false, si no, true
%predicado para verificar stock en sucursal
haystocksuficiente(sucursal, producto, cantidad) :-
    stock(sucursal, producto, stockreal)
    stockreal >= cantidad

%ideal(sucursal, cliente)
ideal(sucursal, cliente) :-
    %genero la sucursal y el cliente antes del forall
    stock(sucursal, _, _), %existe esta sucursal
    busca(cliente, _, _), %existe este cliente
    %"Para todo mueble que busque el cliente, hay stock suficiente en la sucursal"
    %Condicion: busca(cliente, producto, cantidad)
    %Prueba: haystocksuficiente(sucursal, producto, cantidad)
    %forall para verificar condicion universal
    forall(busca(cliente, producto, cantidad), haystocksuficiente(sucursal, producto, cantidad))


    