*&---------------------------------------------------------------------*
*& Report ZPRUEBANES2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpruebanes2.


*Tabla Parametros DIAN
TYPES:

  BEGIN OF gty_parametros,
    name TYPE tvarvc-name,
    low  TYPE tvarvc-low,
  END OF gty_parametros,

  BEGIN OF gtp_segmento_ref,
    nom_seg(3)      TYPE c,
    tip_docref(6)   TYPE c,
    num_docref(150) TYPE c,
    fec_emisio(10)  TYPE c,
    cufe(128)       TYPE c,
    ide_esqid(11)   TYPE c,
  END OF gtp_segmento_ref,

  BEGIN OF gtp_segmento_dcn,
    nom_seg(3)       TYPE c,
    des_natuco(5000) TYPE c,
  END OF gtp_segmento_dcn.

TYPES: gtt_parametros   TYPE STANDARD TABLE OF gty_parametros,
       gtt_segmento_ref TYPE STANDARD TABLE OF gtp_segmento_ref,
       gtt_segmento_dcn TYPE STANDARD TABLE OF gtp_segmento_dcn.

DATA: gti_parametros   TYPE gtt_parametros,
      gti_segmento_ref TYPE gtt_segmento_ref,
      ges_segmento_ref TYPE gtp_segmento_ref,
      gti_segmento_dcn TYPE gtt_segmento_dcn,
      ges_segmento_dcn TYPE gtp_segmento_dcn,
      gwa_parametros   TYPE gty_parametros.

DATA: gv_nomarc       TYPE char255,  "Nombre del archivo.
      gv_fname        TYPE string,   "Linea del archivo,
      gv_format       TYPE string,
      gv_direc        TYPE tvarvc-low, "Directorio,
      lc_num_aux(10)  TYPE c,
      li_long         TYPE i,
      lc_variable(4)  TYPE c.


"MESSAGE 'Estamos realizando ajustes al programa' TYPE 'E'.

"Tabla de parametros
SELECT name low
       FROM tvarvc
  INTO TABLE gti_parametros
  WHERE name LIKE '%ZFELA14%'.

*----------------------------------------------------------------------------*
* . Inicio GLPI: 0234728 - Res. 000165  01.11.2023 Ver.1.9 - NSANCHEZ*
*----------------------------------------------------------------------------*

READ TABLE gti_parametros  INTO gwa_parametros
              WITH KEY name = TEXT-013. "ZFELA14_CUFE

ges_segmento_ref-ide_esqid  = gwa_parametros-low.   "6 REF  Calculo Algoritmo para la nota

ges_segmento_ref-num_docref = '1321'.

lc_variable = 'FEVC'.
CONCATENATE  lc_variable ges_segmento_ref-num_docref  INTO ges_segmento_ref-num_docref.
CONDENSE ges_segmento_ref-num_docref.

li_long = strlen( lc_variable ).
lc_num_aux = ges_segmento_ref-num_docref+li_long(10).
CONDENSE: ges_segmento_ref-ide_esqid,ges_segmento_ref-num_docref,lc_num_aux.
CONCATENATE lc_variable  'Fac' ges_segmento_ref-num_docref INTO ges_segmento_ref-num_docref.

WRITE: / ' Prefijo + Factura ',ges_segmento_ref-num_docref.
WRITE: / ,lc_num_aux.

*----------------------------------------------------------------------------*
* . Fin  GLPI: 0234728 - Res.000165  01.11.2023 Ver.1.9 - NSANCHEZ*
*----------------------------------------------------------------------------*

ges_segmento_dcn-nom_seg = 'DCN'.
ges_segmento_dcn-des_natuco = 'D'.
CONDENSE: ges_segmento_dcn-des_natuco.
APPEND ges_segmento_dcn TO gti_segmento_dcn.



gv_direc = '/tmp/'.
CONCATENATE  gv_direc 'Factura_1321_'  sy-datum '.txt' INTO gv_nomarc.
gv_fname = gv_nomarc.
OPEN DATASET gv_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

"Segmento DCN. descripcion naturaleza correccion Nuevo Segmento Ver. 1.8.
LOOP AT gti_segmento_dcn INTO ges_segmento_dcn.

*  CONCATENATE
*       ges_segmento_dcn-nom_seg    ','
*       ges_segmento_dcn-des_natuco INTO gv_format.
*
*  TRANSFER gv_format TO gv_fname.

ENDLOOP.
