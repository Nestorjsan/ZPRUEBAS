*&---------------------------------------------------------------------*
*& Include          ZSDRXXX0003_PAI
*&---------------------------------------------------------------------*


 MODULE consultar_datos_cliente INPUT.


   CREATE OBJECT g_o_actualizar.

   IF g_es_ztsd0001-zcedula IS NOT INITIAL.
     SELECT  zcedula       "Cedula del cliente
             znombre       "Nombre del cliente
             zdireccion    "Direccion
             ztelefono     "Telefono
             zdepto        "Departamento
             zciudad       "Ciudad
            INTO TABLE g_ti_ztsd0001
          FROM ztsd0001
          WHERE zcedula EQ g_es_ztsd0001-zcedula.
     IF sy-subrc EQ 0.

       READ TABLE g_ti_ztsd0001 INTO g_es_ztsd0001 INDEX 1.

       IF g_ti_ztsd0001 IS NOT INITIAL.
         "Buscamos el departamento
         SELECT zdepto zciudad zdescri
            FROM ztsd0003
            INTO TABLE g_ti_ztsd0003
            FOR ALL ENTRIES IN g_ti_ztsd0001
            WHERE zdepto  EQ g_ti_ztsd0001-zdepto
                AND zciudad EQ '00'.

         READ TABLE g_ti_ztsd0003 INTO g_es_ztsd0003 INDEX 1.
         zdesdepto = g_es_ztsd0003-zdescri.

         "Buscamos la ciudad
         SELECT zdepto zciudad zdescri
            FROM ztsd0003
            INTO TABLE g_ti_ztsdciudad
            FOR ALL ENTRIES IN g_ti_ztsd0001
            WHERE zdepto EQ g_ti_ztsd0001-zdepto
             AND zciudad EQ g_ti_ztsd0001-zciudad.

         READ TABLE g_ti_ztsdciudad INTO g_es_ztsdciudad INDEX 1.
         zdciudad = g_es_ztsdciudad-zdescri.

         "Consultar saldo del cliente
         SELECT zcedula zfecha zsaldo
            FROM ztsd0005
            INTO TABLE g_ti_ztsd0005
            FOR ALL ENTRIES IN g_ti_ztsd0001
            WHERE zcedula EQ g_ti_ztsd0001-zcedula.

         READ TABLE g_ti_ztsd0005 INTO g_es_ztsd0005 INDEX 1.
         g_e_saldo = g_es_ztsd0005-zsaldo.

       ENDIF.
     ELSE.
       MESSAGE TEXT-mne TYPE TEXT-00i.
       LEAVE TO SCREEN 0.
     ENDIF.
   ELSE.
     MESSAGE TEXT-mce TYPE TEXT-00i.
     CALL SCREEN 0110.
   ENDIF.
 ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CONSULTAR_DATOS_PRODUCTO  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 MODULE consultar_datos_producto INPUT.
   IF g_es_detalle-zcodpro IS NOT INITIAL.
     SELECT  zcodpro           "Codigo del producto
             zdescri           "Descripción del producto
                INTO TABLE g_ti_ztsd0004
              FROM ztsd0004
              WHERE zcodpro EQ g_es_detalle-zcodpro.
     IF sy-subrc EQ 0.
       READ TABLE g_ti_ztsd0004 INTO g_es_ztsd0004 INDEX 1.
       g_es_detalle-zdescri = g_es_ztsd0004-zdescri.
     ELSE.
       MESSAGE TEXT-mpr TYPE TEXT-00i.
     ENDIF.
   ENDIF.

 ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CALCULO_VALOR_TOTAL  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 MODULE calculo_valor_total INPUT.
   g_es_detalle-ztotal = g_es_detalle-zcantidad * g_es_detalle-zvalor.
 ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 MODULE user_command_0110 INPUT.
   CASE ok_code.
     WHEN 'BACK'.
       LEAVE TO SCREEN 0.
     WHEN 'EXIT'.
       LEAVE PROGRAM.
       "LEAVE TO TRANSACTION 'ZSD04O'.
     WHEN 'CANCEL'.
       LEAVE TO SCREEN 0.
     WHEN '&MODIFICAR'.
       "PERFORM modificar_registro.

     WHEN OTHERS.
   ENDCASE.

 ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CONSULTAR_REGIS_DETALLE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
 MODULE consultar_regis_detalle INPUT.
   IF g_es_ztsd0001-zcedula IS NOT INITIAL.
     SELECT
        zcodpro         "Codigo del producto
        zdescri         "Descripción del producto
        zcantidad       "Cantidad
        zvalor          "Valor
        ztotal          "Total
       FROM ztsd0002
       INTO TABLE g_ti_detalle
       WHERE zfactura EQ  g_es_ztsd0001-zfactura
        AND zcedula EQ g_es_ztsd0001-zcedula.

     LOOP AT g_ti_detalle INTO g_es_detalle.
       "g_e_total = g_e_total + g_es_detalle-ztotal.
     ENDLOOP.
     g_ti_detalle_cop[] = g_ti_detalle[].
   ELSE.
     MESSAGE TEXT-mce TYPE TEXT-00i.
     CLEAR g_o_actualizar.
     CALL SCREEN 0110.
   ENDIF.
 ENDMODULE.
