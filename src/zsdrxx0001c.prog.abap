*&---------------------------------------------------------------------*
* Información General
*----------------------------------------------------------------------*
* Programa     : ZSDRXXX0001
* Tipo Objeto  : REPORT
* Descripción  : Repoerte de clientes
* Empresa      : Empresa 01
* Autor Prog.  : NSANCHEZ - Néstor Javier Sánchez Sánchez
* Fecha Creac. : 11.10.2023
*----------------------------------------------------------------------*
* Ordenes de Transporte   NPLK900086
*----------------------------------------------------------------------*

REPORT ZSDRXX0001C.

INCLUDE ZSDRXXX0001C_TOP.
*INCLUDE ZSDRXXX0001_TOP.
INCLUDE ZSDRXXX0001C_SEL.
*INCLUDE ZSDRXXX0001_SEL.
INCLUDE ZSDRXXX0001C_FORM.
*INCLUDE ZSDRXXX0001_FORM.

START-OF-SELECTION.

PERFORM f_consulta_datos.
PERFORM f_build_fieldcatalog.
PERFORM f_alv_report.
