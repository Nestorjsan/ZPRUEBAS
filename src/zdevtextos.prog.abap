*&---------------------------------------------------------------------*
*& Report ZDEVTEXTOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDEVTEXTOS.

*&---------------------------------------------------------------------*
* Información General
*----------------------------------------------------------------------*
* Programa     : ZSDRXXX0001
* Tipo Objeto  : REPORT
* Descripción  : Cantidad de caracteres de un texto
* Empresa      : Almacenes La 14 S.A.
* Autor Prog.  : NSANCHEZ - Néstor Javier Sánchez Sánchez
* Fecha Creac. : 11.10.2023
*----------------------------------------------------------------------*
* Ordenes de Transporte   NPLK900097
*----------------------------------------------------------------------*

INCLUDE ZDEVTEXTOS_TOP.
INCLUDE ZDEVTEXTOS_SEL.
INCLUDE ZDEVTEXTOS_FORM.


START-OF-SELECTION.

PERFORM f_consulta_texto.
