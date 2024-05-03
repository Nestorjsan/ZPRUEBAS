*&---------------------------------------------------------------------*
*& Include          ZFIRXXX0002_FORM
*&---------------------------------------------------------------------*

FORM f_consulta_datos.

  CALL FUNCTION 'ZFI_FM_FACELE'
    EXPORTING
      tip_docu = pa_doc
    IMPORTING
      num_fac  = gc_numfac.

   DATA lc_variable(100) TYPE c.

  CONCATENATE' Factura Número..: ' gc_numfac INTO lc_variable SEPARATED BY ' '.
  CONDENSE lc_variable.

  WRITE: / lc_variable.



ENDFORM.
