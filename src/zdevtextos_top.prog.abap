*&---------------------------------------------------------------------*
*& Include          ZDEVTEXTOS_TOP
*&---------------------------------------------------------------------*
DATA: g_ti_lineas      TYPE STANDARD TABLE OF tline,
      g_c_lineas       TYPE tline,
      g_es_header      TYPE thead,
      g_d_fila         TYPE i,
      g_c_texto        TYPE string,
      g_c_texto1(132)  TYPE c,
      g_c_texto2(132)  TYPE c,
      g_c_texto3(132)  TYPE c,
      g_c_texto4(132)  TYPE c,
      g_c_texto5(132)  TYPE c,
      g_c_texto6(132)  TYPE c,
      g_c_texto7(132)  TYPE c,
      g_c_texto8(132)  TYPE c,
      g_c_texto9(132)  TYPE c,
      g_c_texto10(132) TYPE c,
      g_d_contador     TYPE i,
      g_c_texnum(6)    TYPE c,
      g_c_nomtex(70)   TYPE c,
      g_c_message      TYPE string,
      g_c_pos_01(2000) TYPE c,
      g_c_tdname       TYPE stxh-tdname,
      g_c_low          TYPE tvarvc-low.
