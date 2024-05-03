FUNCTION-POOL ZFI_FG_FACELE.                "MESSAGE-ID ..

*INCLUDE LZFI_FG_FACELED...                 " Local class definition

TYPES:

  BEGIN OF gtp_segmento_enc,
    nom_seg(3)    TYPE c,
    tip_doc(6)    TYPE c,
    nit_obf(35)   TYPE c,
    ide_adq(35)   TYPE c,
    esq_ubl(8)    TYPE c,
*----------------------------------------------------------------------------*
* . Inicio Control de Cambio: 584 - Resolución 000012 - 09.02.2021 - NSANCHEZ*
*----------------------------------------------------------------------------*
    for_doc(55)   TYPE c,
*--------------------------------------------------------------------------*
* . Fin Control de Cambio: 584 - Resolución 000012 - 09.02.2021 - NSANCHEZ *
*--------------------------------------------------------------------------*
    num_doc(20)   TYPE c,
    fec_emi(10)   TYPE c,
    hor_emi(14)   TYPE c,
    tip_fac(3)    TYPE c,
    moneda(3)     TYPE c,
    fhi_pef(25)   TYPE c,
    fhi_fip(25)   TYPE c,
    num_cec(70)   TYPE c,
    des_cec(100)  TYPE c,
    num_tld(500)  TYPE c,
    fec_ven(10)   TYPE c,
    url_ear(2048) TYPE c,
    url_pag(2048) TYPE c,
    uni_nve(100)  TYPE c,
    amb_des(1)    TYPE c,
    ind_top(4)    TYPE c,
    fec_pim(10)   TYPE c,
  END OF gtp_segmento_enc,

  BEGIN OF gtp_segmento_cdn,
    nom_seg(3)        TYPE c,
    cod_tipcon(1)     TYPE c,
    des_natucor(5000) TYPE c,
    sec_factor(20)    TYPE c,
  END OF gtp_segmento_cdn,


  BEGIN OF gtp_segmento_ref,
    nom_seg(3)      TYPE c,
    tip_docref(6)   TYPE c,
    num_docref(150) TYPE c,
    fec_emisio(10)  TYPE c,
    cufe(128)       TYPE c,
    ide_esqid(11)   TYPE c,
  END OF gtp_segmento_ref,

  BEGIN OF gty_parametros,
    name TYPE tvarvc-name,
    low  TYPE tvarvc-low,
  END OF gty_parametros.

*------------------------------------------------------------------------*
* Declaración de Areas de Trabajo                                        *
*------------------------------------------------------------------------*
DATA: ges_segmento_enc TYPE  gtp_segmento_enc,
      ges_segmento_ref TYPE  gtp_segmento_ref,
      ges_segmento_cdn TYPE  gtp_segmento_cdn,
      gwa_parametros   TYPE  gty_parametros.

*------------------------------------------------------------------------*
* Declaración de Tipos                                                   *
*------------------------------------------------------------------------*
TYPES: gtt_segmento_enc TYPE STANDARD TABLE OF  gtp_segmento_enc,
       gtt_segmento_ref TYPE STANDARD TABLE OF  gtp_segmento_ref,
       gtt_segmento_cdn TYPE STANDARD TABLE OF  gtp_segmento_cdn,
       gtt_parametros   TYPE STANDARD TABLE OF  gty_parametros.

DATA: gti_segmento_enc   TYPE STANDARD TABLE OF  gtp_segmento_enc,
      gti_segmento_ref   TYPE STANDARD TABLE OF  gtp_segmento_ref,
      gti_segmento_cdn   TYPE STANDARD TABLE OF  gtp_segmento_cdn,
      gti_parametros_not TYPE gtt_parametros.

*------------------------------------------------------------------------*
* Declaración de Tablas de Rangos                                        *
*------------------------------------------------------------------------*
RANGES : gvr_tipnota FOR ges_segmento_enc-tip_fac,             "Tipos de notas
         gvr_tipope  FOR ges_segmento_enc-ind_top.              "Tipo de operación.

FIELD-SYMBOLS: <lfs_seg_enc> TYPE gtp_segmento_enc,
               <lfs_seg_cdn> TYPE gtp_segmento_cdn.
