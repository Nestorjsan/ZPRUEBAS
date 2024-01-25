*&---------------------------------------------------------------------*
*& Include          ZDEVTEXTOS_TOP
*&---------------------------------------------------------------------*
DATA: gti_lineas       TYPE STANDARD TABLE OF tline,
      gwa_lineas       TYPE tline,
      ls_header        TYPE thead,
      ld_fila          TYPE i,
      gv_texto         TYPE string,
      gv_texto1(132)   TYPE c,
      gv_texto2(132)   TYPE c,
      gv_texto3(132)   TYPE c,
      gv_texto4(132)   TYPE c,
      gv_texto5(132)   TYPE c,
      gv_texto6(132)   TYPE c,
      gv_texto7(132)   TYPE c,
      gv_texto8(132)   TYPE c,
      gv_texto9(132)   TYPE c,
      gv_texto10(132)  TYPE c,
      g_es_contador    TYPE i,
      g_es_texnum(6)   TYPE c,
      g_es_texto(70)   TYPE c,
      lv_message       TYPE string,
      ges_pos_01(2000) TYPE c.


TYPES: BEGIN OF gty_parametros,
         name TYPE tvarvc-name,
         low  TYPE tvarvc-low,
       END OF gty_parametros.

TYPES: BEGIN OF gty_stxh,
         tdname TYPE stxh-tdname,
       END OF gty_stxh.

TYPES:
 gtt_parametros TYPE STANDARD TABLE OF  gty_parametros,
 gtt_sthx       TYPE STANDARD TABLE OF  gty_stxh.

DATA: gti_parametros TYPE gtt_parametros,
      ges_parametros TYPE gty_parametros,
      gti_stxh       TYPE gtt_sthx,
      ges_stxh       TYPE gty_stxh.
