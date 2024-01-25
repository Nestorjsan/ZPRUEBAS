*&---------------------------------------------------------------------*
*& Report ZPRUEBANES
*&---------------------------------------------------------------------*
*&Pruebas Desarrollo
*&---------------------------------------------------------------------*
REPORT zpruebanes.

DATA: gwa_fecha          TYPE d,
      gwa_forfec(25)     TYPE c,
      gwa_hora(16)       TYPE c,
      gwa_telcon(30)     TYPE c,
      gwa_telcon1(10)    TYPE c,
      gwa_telsd          TYPE ad_tlnmbr,
      gwa_ind(30)        TYPE c,
      cde_telpercon(10)  TYPE c,
      cde_corpercon(100) TYPE c,
      cde_telfax(10)     TYPE c.

gwa_fecha = sy-datum.
gwa_hora = 'T00:01:01-05:00'.
CONCATENATE    gwa_fecha+0(4) '-'
               gwa_fecha+4(2) '-'
               gwa_fecha+6(2)
               gwa_hora INTO gwa_forfec.

gwa_telcon   = '032 4881414'.
gwa_telcon1  = gwa_telcon+4(7).
REPLACE TEXT-032 IN gwa_telcon WITH space.
CONDENSE gwa_telcon.


CONDENSE gwa_telsd.

*WRITE: / 'Formato Fecha Año-Mes_Día: ',gwa_forfec.
*WRITE: / 'Telefono Contacto........: ',gwa_telcon1.
*WRITE: / 'Telefono Contacto SD.....: ',gwa_telcon.

TYPES: BEGIN OF gty_adr2,

         addrnumber TYPE  adr2-addrnumber,
         tel_number TYPE  adr2-tel_number,

       END OF gty_adr2.

TYPES: BEGIN OF gty_adr6,

         addrnumber TYPE  adr6-addrnumber,
         consnumber TYPE  adr6-consnumber,
         smtp_addr  TYPE  adr6-smtp_addr,
         smtp_srch  TYPE  adr6-smtp_srch,

       END OF gty_adr6.

TYPES: BEGIN OF gty_adr3,

         addrnumber TYPE  adr3-addrnumber,
         fax_number TYPE  adr3-fax_number,

       END OF gty_adr3.

TYPES:
  gtt_adr2 TYPE STANDARD TABLE OF  gty_adr2,
  gtt_adr6 TYPE STANDARD TABLE OF  gty_adr6,
  gtt_adr3 TYPE STANDARD TABLE OF  gty_adr3.

DATA: gti_adr2 TYPE  gtt_adr2,
      gti_adr6 TYPE  gtt_adr6,
      gti_adr3 TYPE  gtt_adr3,
      gwa_adr2 TYPE  gty_adr2,
      gwa_adr6 TYPE  gty_adr6,
      gwa_adr3 TYPE  gty_adr3.

*Adicionar datos a la tabla interna

gwa_adr2-addrnumber = '2024'.
gwa_adr2-tel_number = '032 3921955'.
APPEND gwa_adr2 TO gti_adr2.

gwa_adr2-addrnumber = '2024'.
gwa_adr2-tel_number = '3014478838'.
APPEND gwa_adr2 TO gti_adr2.

*Adicionar datos correo electronico
gwa_adr6-addrnumber = '2024'.
gwa_adr6-consnumber = '001'.
gwa_adr6-smtp_addr  = 'servicioalcliente@la14.com'.
gwa_adr6-smtp_srch  = 'SERVICIOALCLIENTE@LA'.
APPEND gwa_adr6 TO gti_adr6.


gwa_adr6-addrnumber = '2024'.
gwa_adr6-consnumber = '003'.
gwa_adr6-smtp_addr  = 'proteconsum@la14.com'.
gwa_adr6-smtp_srch  = 'PROTECONSUM@LA14.COM'.

*fax
gwa_adr3-addrnumber = '2024'.
gwa_adr3-fax_number = '032 6651869'.
APPEND gwa_adr3 TO gti_adr3.

*Telefono FI-RE
*READ TABLE gti_adr2 INTO gwa_adr2 INDEX 1.
**   WITH KEY addrnumber = '2024'
**   BINARY SEARCH.
*IF  sy-subrc EQ 0.
*  CONCATENATE cde_telpercon gwa_adr2-tel_number+4(7) INTO  cde_telpercon.
*  CONDENSE cde_telpercon.
*ENDIF.

*Telefono SD
DATA lc_tel(30) TYPE C.
READ TABLE gti_adr2 INTO gwa_adr2 INDEX 1.
REPLACE TEXT-032 IN gwa_adr2-tel_number WITH space.
CONDENSE gwa_adr2-tel_number .
"CONCATENATE gwa_adr2-tel_number INTO lc_tel.
cde_telpercon = gwa_adr2-tel_number.

READ TABLE gti_adr6 INTO gwa_adr6
WITH KEY addrnumber = '2024'
BINARY SEARCH.
IF  sy-subrc EQ 0.
  CONCATENATE cde_corpercon gwa_adr6-smtp_addr INTO cde_corpercon.
  CONDENSE cde_corpercon.
ENDIF.

READ TABLE gti_adr3 INTO gwa_adr3
   WITH KEY addrnumber = '2024'
   BINARY SEARCH.
IF  sy-subrc EQ 0.
  CONCATENATE cde_telfax gwa_adr3-fax_number+4(7) INTO cde_telfax.
  CONDENSE cde_telfax.
ENDIF.
"cde_telpercon(1) = space.
WRITE: / 'Telefono Contacto .......: ',cde_telpercon.
WRITE: / 'Correo del Contacto......: ',cde_corpercon.
WRITE: / 'Fax del Contacto.........: ',cde_telfax.
