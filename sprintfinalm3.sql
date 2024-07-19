-- Se debe crear un usuario con privilegios para crear, eliminar y modificar tablas, insertar registros

create database telovendosprint;
create user 'sprint'@'localhost' identified by 'admin1';
grant CREATE, DROP, ALTER, INSERT, UPDATE, DELETE, SELECT ON telovendosprint.* to 'sprint'@'localhost' with grant option;
flush privileges;

create table categorias(
	id_categoria int auto_increment not null primary key,
    nombre varchar(100) not null
);

insert into categorias (nombre)
values
('Televisores'),
('Computadoras'),
('Celulares'),
('Cámaras'),
('Audifonos');

select * from categorias;

create table provedores(
	id_provedores int auto_increment not null primary key,
    nombre_representante varchar(100) not null,
    nombre_corporativo varchar(100) not null,
    telefono1 varchar(100) not null,
    telefono2 varchar(100) not null,
    secretaria varchar(100) not null,
    categorias int not null,
    correo varchar(100) not null,
    foreign key (categorias) references categorias (id_categoria)
);

insert into provedores(nombre_representante, nombre_corporativo, telefono1, telefono2, secretaria, categorias, correo)
values
('Juan Pérez', 'Corp ABC', '+56 9 1234 5678', '+56 2 2345 6789', 'Ana López', 1, 'juan.perez@abc.com'),
('María García', 'Tech Solutions', '+56 9 2345 6789', '+56 2 3456 7890', 'Carlos Méndez', 2, 'maria.garcia@techsolutions.com'),
('Luis Fernández', 'Global Supplies', '+56 9 3456 7890', '+56 2 4567 8901', 'Lucía Sánchez', 3, 'luis.fernandez@globalsupplies.com'),
('Ana Gómez', 'Office World', '+56 9 4567 8901', '+56 2 5678 9012', 'Pedro Díaz', 4, 'ana.gomez@officeworld.com'),
('Carlos Martínez', 'Food Services', '+56 9 5678 9012', '+56 2 6789 0123', 'María Torres', 5, 'carlos.martinez@foodservices.com');

select * from provedores;

create table clientes (
	id_cliente int auto_increment not null primary key,
    nombre_cliente varchar(100) not null,
    apellido_cliente varchar(100) not null,
    direccion_cliente varchar(100) not null
);

insert into clientes (nombre_cliente, apellido_cliente, direccion_cliente)
values
('Carlos', 'Ramirez', 'Calle 1, Ciudad A'),
('María', 'González', 'Calle 2, Ciudad B'),
('Luis', 'Fernández', 'Calle 3, Ciudad C'),
('Ana', 'Martínez', 'Calle 4, Ciudad D'),
('Pedro', 'López', 'Calle 5, Ciudad E'),
('Laura', 'Pérez', 'Calle 6, Ciudad F'),
('Jorge', 'Gómez', 'Calle 7, Ciudad G'),
('Elena', 'Sánchez', 'Calle 8, Ciudad H'),
('Miguel', 'Díaz', 'Calle 9, Ciudad I'),
('Sofía', 'Torres', 'Calle 10, Ciudad J');

select * from clientes;

create table productos (
	id_productos int auto_increment not null primary key,
    precio bigint not null,
    categorias int not null,
    provedor int not null,
    color varchar(100) not null,
    stock int not null,
    foreign key (categorias) references categorias (id_categoria),
    foreign key (provedor) references provedores (id_provedores)
);

insert into productos (precio, categorias, provedor, color, stock)
values
(20100, 2, 2, 'Blanco', 10),
(30560, 2, 3, 'Blanco', 5),
(60590, 3, 4, 'Rojo', 15),
(35680, 4, 5, 'Azul', 16),
(41590, 5, 1, 'Verde', 24),
(26590, 1, 2, 'Amarillo', 31),
(78490, 3, 3, 'Naranja', 51),
(35690, 5, 4, 'Morado', 40),
(41860, 2, 5, 'Gris', 8),
(86150, 1, 1, 'Marrón', 6);

select * from productos;

-- Consultas SQL --

-- Cuál es la categoría de productos que más se repite.
select categorias.nombre, count(*) as cantidad
from productos
join categorias on productos.categorias = categorias.id_categoria
group by productos.categorias
order by cantidad
desc
limit 1;
-- La categoria que mas se repite es "Computadoras"

-- Cuales son los productos con mayor stock
select id_productos, categorias.nombre as categoria, stock
from productos
join categorias on productos.categorias = categorias.id_categoria
order by stock
desc
limit 1;
-- Los productos con mayor stock son los celulares, con un stock total de 51

-- Qué color de producto es más común en nuestra tienda.
select color, count(*) as cantidad
from productos
group by color
order by cantidad
desc
limit 1;
-- El color que es más común en nuestra tienda es el blanco

-- Cual o cuales son los proveedores con menor stock de productos.
select provedores.nombre_corporativo, sum(stock) as total
from productos
join provedores on productos.provedor = provedores.id_provedores
group by provedor
order by total
asc
limit 1;
-- El proveedor con menos stock es 'Food Services' con un valor total de 24 productos


-- Cambien la categoría de productos más popular por 'Electrónica y computación'

-- La categoría de productos más popular es 'Computadoras' y se cambiará a 'Electrónica y computación'
Update categorias
SET nombre = 'Electrónica y computación'
WHERE id_categoria = (
	SELECT categorias
    FROM productos
    GROUP BY categorias
    ORDER BY COUNT(*)
    DESC
    LIMIT 1
);

-- Se revisa que el cambio se haya aplicado correctamente
select categorias.nombre, count(*) as cantidad
from productos
join categorias on productos.categorias = categorias.id_categoria
group by productos.categorias
order by cantidad
desc
limit 1;
-- La categoria que mas ahora es "Electrónica y computación"


