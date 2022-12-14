
--1 
SELECT*

FROM Productores_Básicos pb

--HACEMOS UN JOIN CON UNA TABLA NUEVA QUE TENDRÁ DOS COLUMNAS: UNA CON LOS NIFS Y OTRA CON LA CANTIDAD DE VECES QUE APARECEN (SIEMPRE QUE APAREZCAN MÁS DE DOS VECES)

JOIN (SELECT NIF_PB FROM centrales_electricidad GROUP BY NIF_PB HAVING COUNT(*) > 2)

USING (NIF_PB)

--TODOS LOS QUE TENGAN AUTORIZACIÓN EN VIGOR Y TENGAN LA FORMA DE SA

WHERE (pb.fecha_final > SYSDATE) AND (pb.denom= ‘S.A’);


--2

SELECT *

FROM Eólica

--CENTRALES CUYA PRODUCCIÓN MEDIA SUPERIOR A LA MEDIA DE CUALQUIER OTRA
CENTRAL

WHERE prod_media_por_hora = (
SELECT MAX (prod_media_por_hora)
FROM Eólica
)
--TODAS LAS CENTRALES ELÉCTRICAS QUE HAYAN PRODUCIDO ELECTRICIDAD EN EL ÚLTIMO MES

AND ((prod_media_por_hora) > 0 );


--3

DECLARE
    a NUMBER;
PROCEDURE Medias (vMedio IN OUT NUMBER) IS 
BEGIN 
---CALCULAMOS EL VALOR DIARIO A PARTIR DE UNO DADO
    a := vMedio * 24; 
    DBMS_OUTPUT.PUT_LINE(' Media Diaria: ' || a);
--A PARTIR DEL DIARIO, Y SEGÚN EL MES, CALCULAMOS EL MENSUAL
    if (MONTH(sysdate)%2 ==0)
        a := a * 30;
 else  
        a := a * 31;
    DBMS_OUTPUT.PUT_LINE (' Media Mensual: ' || a);
--CALCULAMOS EL ANUAL
    a := a *365;
    DBMS_OUTPUT.PUT_LINE(' Media Anual: ' || a);
END;
--LLAMADA AL PROCEDIMIENTO
BEGIN 
    a:= 78; 
    Medias (a); 

END; 

--4

CREATE TRIGGER Trigger_Alerta 
AFTER INSERT ON Inventario_Alertas  
DECLARE  
	
CURSOR C_ALERTA IS  
	
	
SELECT TIPO,COD_CENTRAL FROM INVENTARIO_ALERTAS; 
TIPO_N INVENTARIO_ALERTAS.TIPO%TYPE; 
COD_CENTRAL INVENTARIO_ALERTAS.COD_CENTRAL%TYPE; 
BEGIN 
IF INSERTING THEN 
OPEN C_ALERTA; 
LOOP 
	
 
FETCH TIPO_N,COD_CENTRAL INTO ALERTAS; 
EXIT WHEN C_ALERTA%NOTFOUND; 
DMBS_OUTPUT.PUT_LINE(COD_CENTRAL); 
  
END LOOP; 
CLOSE C_ALERTA; 
END IF; 
END;


--5

DECLARE
    usuario VARCHAR(6) := &valor;
    c varchar(6);
    
BEGIN

    SELECT e.nombre INTO c FROM entregar2 e
    inner join productores_básicos pb on e.nif_pb = pb.nif_pb
    inner join centrales_electricidad cd on pb.nif_pb = cd.nif_pb
    
    WHERE c = usuario;
    
END;


--6

DECLARE  
D_ZONA_SERVICIO VARCHAR(9) = &VALUE1; 
COD_PROVINCIA VARCHAR(9)= &VALUE2; 
  
BEGIN   
  
SELECT CENTRALES, LÍNEAS, ESTACIONES, SUBESTACIONES, CONSUMIDORES 
  
FROM (ZONA_SERVICIO JOIN distribuir JOIN SUBESTACION JOIN linea JOIN Redes_Distribución JOIN REDES_DISTRIBUCIÓN JOIN ESTACIÓN_PRIMARIA JOIN ENTREGAR2 JOIN REGISTRAR JOIN CONSUMIDORES) 
  
WHERE (ID_ZONA_SERVICIO = VALUE1, CÓD_PROVINCIA = VALUE2) && (CENTRALES_ELECTRICAS.COD_CENTRAL = EÓLICA.COD_CENTRAL) 