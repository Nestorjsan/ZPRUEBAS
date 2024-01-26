*&---------------------------------------------------------------------*
*& Report ZDEVTEXTOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDEVTEXTOS.

*&---------------------------------------------------------------------*
* Información General
*----------------------------------------------------------------------*
* Programa     : ZDEVTEXTOS
* Tipo Objeto  : REPORT
* Descripción  : Cantidad de caracteres de un texto
* Empresa      :
* Autor Prog.  : NSANCHEZ - Néstor Javier Sánchez Sánchez
* Fecha Creac. : 11.03.2022
*----------------------------------------------------------------------*
* Ordenes de Transporte
*----------------------------------------------------------------------*

INCLUDE ZDEVTEXTOS_TOP.
INCLUDE ZDEVTEXTOS_SEL.
INCLUDE ZDEVTEXTOS_FORM.


START-OF-SELECTION.

PERFORM f_consulta_texto.
