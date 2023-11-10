*----------------------------------------------------------------------*
* Información General
*----------------------------------------------------------------------*
* Programa     : ZSDRXXX0004
* Tipo Objeto  : Programa
* Descripción  : Impresión factura
* Empresa      : Proyect asociados Sánchez
* Autor Prog.  : DEVELOPER - Néstor Javier Sánchez Sánchez
* Fecha Creac. : 08.11.2023
*----------------------------------------------------------------------*
* Ordenes de Transporte   NPLK900083
* Modulo       : SD
* Transacción  : ZSD041
*----------------------------------------------------------------------*
REPORT ZSDRXXX0004.

INCLUDE ZSDRXXX0004_TOP.
INCLUDE ZSDRXXX0004_SEL.
INCLUDE ZSDRXXX0004_FORM.

START-OF-SELECTION.

PERFORM f_consulta_datos.
