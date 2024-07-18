*&---------------------------------------------------------------------*
*& Report ZFIRXXX0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFIRXXX0001.


INCLUDE zfirxxx0001_top.
INCLUDE zfirxxx0001_sel.
INCLUDE zfirxxx0001_form.

START-OF-SELECTION.

PERFORM f_mapear_info_segmentos CHANGING gti_segmento_enc
                                         gti_segmento_cdn
                                         gti_segmento_ref.
