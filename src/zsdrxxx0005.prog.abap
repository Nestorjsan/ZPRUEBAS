*----------------------------------------------------------------------*
* Información General
*----------------------------------------------------------------------*
* Programa     : ZSDRXXX0005
* Tipo Objeto  : Programa
* Descripción  : Envio Mail Archivo Adjunto Smartform
* Empresa      : Proyect asociados Sánchez
* Autor Prog.  : DEVELOPER - Néstor Javier Sánchez Sánchez
* Fecha Creac. : 13.11.2023
*----------------------------------------------------------------------*
* Ordenes de Transporte   NPLK900085
* Modulo       : SD
* Transacción  : ZSD04X
*----------------------------------------------------------------------*
REPORT ZSDRXXX0005.

INCLUDE ZSDRXXX0005_TOP.
INCLUDE ZSDRXXX0005_SEL.
INCLUDE ZSDRXXX0005_CLA.

START-OF-SELECTION.


  CREATE OBJECT obj_factura_oo.
  CALL METHOD obj_factura_oo->send_mail_customer.
