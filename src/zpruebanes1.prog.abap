*&---------------------------------------------------------------------*
*& Report ZPRUEBANES1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpruebanes1.

DATA: gti_lineas      TYPE STANDARD TABLE OF tline,
      gwa_lineas      TYPE tline,
      ls_header       TYPE thead,
      ld_fila         TYPE i,
      gv_texto        TYPE string,
      gv_texto1(132)  TYPE c,
      gv_texto2(132)  TYPE c,
      gv_texto3(132)  TYPE c,
      gv_texto4(132)  TYPE c,
      gv_texto5(132)  TYPE c,
      gv_texto6(132)  TYPE c,
      gv_texto7(132)  TYPE c,
      gv_texto8(132)  TYPE c,
      gv_texto9(132)  TYPE c,
      gv_texto10(132) TYPE c,
      g_es_contador   TYPE i,
      g_es_texnum(6)  TYPE c,
      g_es_texto(70)  TYPE c.


TYPES: BEGIN OF gtp_not1,

         nom_seg(3)   TYPE c,
         pos_01(2000) TYPE c,

       END OF gtp_not1.

TYPES:
 gtt_not1          TYPE STANDARD TABLE OF  gtp_not1.

DATA: gti_not1 TYPE STANDARD TABLE OF  gtp_not1,
      ges_not1 TYPE  gtp_not1.

g_es_texto = 'ZFELA14_46'.
CONDENSE g_es_texto.

CALL FUNCTION 'READ_TEXT'
  EXPORTING
    id                      = 'ST'             "ID del texto
    language                = 'S'             "Idioma
    name                    = g_es_texto    "Texto
    object                  = 'TEXT'           "Esto es constante
  IMPORTING
    header                  = ls_header
  TABLES
    lines                   = gti_lineas
  EXCEPTIONS
    id                      = 1
    language                = 2
    name                    = 3
    not_found               = 4
    object                  = 5
    reference_check         = 6
    wrong_access_to_archive = 7
    OTHERS                  = 8.

ld_fila = 1.
LOOP AT gti_lineas INTO gwa_lineas.

  CASE ld_fila.

    WHEN 1.
      gv_texto1 = gwa_lineas-tdline.
    WHEN 2.
      gv_texto2 = gwa_lineas-tdline.
    WHEN 3.
      gv_texto3 = gwa_lineas-tdline.
    WHEN 4.
      gv_texto4 = gwa_lineas-tdline.
    WHEN 5.
      gv_texto5 = gwa_lineas-tdline.
    WHEN 6.
      gv_texto6 = gwa_lineas-tdline.
    WHEN 7.
      gv_texto7 = gwa_lineas-tdline.
    WHEN 8.
      gv_texto8 = gwa_lineas-tdline.
    WHEN 9.
      gv_texto9 = gwa_lineas-tdline.
    WHEN 10.
      gv_texto10 = gwa_lineas-tdline.
  ENDCASE.

  ld_fila = ld_fila + 1.

ENDLOOP.

CONCATENATE gv_texto1 ' ' gv_texto2 ' ' gv_texto3 ' ' gv_texto4 ' ' gv_texto5 ' '
            gv_texto6 ' ' gv_texto7 ' ' gv_texto8 ' ' gv_texto9 ' ' gv_texto10 INTO gv_texto.
REPLACE '<N>' WITH space INTO gv_texto.
REPLACE '</>' WITH space INTO gv_texto.
CONDENSE gv_texto.

"ges_not1-nom_seg = 'NOT'.
CONCATENATE '1.-' gv_texto INTO ges_not1-pos_01.
CONDENSE ges_not1-pos_01.
APPEND ges_not1 TO gti_not1.

g_es_contador = strlen( ges_not1-pos_01 ).
"g_es_canlet   = g_es_contador.
IF g_es_contador > 240.
  DATA lv_message TYPE string.
  g_es_texnum = g_es_contador.
  CONCATENATE 'El texto ' g_es_texto ' sobre pasa la cantidad de caracteres permitidos de 240, tiene ' g_es_texnum INTO lv_message SEPARATED BY space.
  MESSAGE lv_message TYPE 'I' .
ENDIF.
"g_es_contador = strlen( gv_texto ).
WRITE: / ' Tamaño del Texto ',g_es_contador.
