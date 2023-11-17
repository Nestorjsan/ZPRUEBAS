*&---------------------------------------------------------------------*
*& Include          ZSDRXXX0005_CLA
*&---------------------------------------------------------------------*

CLASS zftf_factura DEFINITION.
  PUBLIC SECTION.
* Customer
    DATA : mv_email TYPE adr6-smtp_addr,
           mv_name  TYPE name1_gp.
* Smartform
    CONSTANTS :
      gc_format   TYPE so_obj_tp VALUE 'PDF',
      gc_formname TYPE tdsfname VALUE 'ZSDFAPV001'.
* PDF
    DATA: mv_pdf_content TYPE solix_tab,
          mv_pdf_size    TYPE so_obj_len,
          mt_items       TYPE g_tp_ti_smartform.
    METHODS: get_customer_data, "IMPORTING iv_kunnr TYPE kunnr,
      create_pdf,
      send_mail,
      send_mail_customer.
ENDCLASS.

CLASS zftf_factura IMPLEMENTATION.

  METHOD create_pdf.

    DATA : lt_job_output_info TYPE ssfcrescl,
           lv_fm_name         TYPE rs38l_fnam,
           lv_size            TYPE i,
           lt_lines           TYPE TABLE OF tline.
* Getting Function Module name based on the Smartform name
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = gc_formname " Form name
      IMPORTING
        fm_name            = lv_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    "Disabled Dialog and get OTF of SMARTFORM
    DATA(ls_control_parameters) = VALUE ssfctrlop( no_dialog = abap_true
                                                     preview = space
                                                      getotf = abap_true ).
    "Disabled preview SMARTFORM
    DATA(ls_output_options) = VALUE ssfcompop( tdnoprev = abap_true ).

    DATA lv_qr TYPE string.
* Generating the Smartform
    CALL FUNCTION lv_fm_name
      EXPORTING
        control_parameters = ls_control_parameters
        output_options     = ls_output_options
      IMPORTING
        job_output_info    = lt_job_output_info
      TABLES
        g_ti_smartform     = g_ti_smartform
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


* Convert OTF to PDF XString
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = gc_format
      IMPORTING
        bin_filesize          = lv_size
      TABLES
        otf                   = lt_job_output_info-otfdata
        lines                 = lt_lines
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        err_bad_otf           = 4
        OTHERS                = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    "PDF
    FIELD-SYMBOLS <l_xline> TYPE x.
    LOOP AT lt_lines INTO DATA(ls_lines).
      ASSIGN ls_lines TO <l_xline> CASTING.
      CONCATENATE pdf_xstring <l_xline> INTO DATA(pdf_xstring) IN BYTE
     MODE.
    ENDLOOP.
* PDF XString to Solix
* Wrapper Class for Office Documents - BCS Business Communication Service

    mv_pdf_size = xstrlen( pdf_xstring ).
    mv_pdf_content = cl_document_bcs=>xstring_to_solix( ip_xstring = pdf_xstring ).

  ENDMETHOD.

  METHOD get_customer_data.



    SELECT  zfactura      "Número de la factura
        zcedula       "Cedula del cliente
        zcodpro       "Codigo del producto
        zdescri       "Descripción del producto
        zcantidad     "Cantidad
        zvalor        "Valor
        ztotal        "Total
        zfecfac       "Fecha Factura
         FROM ztsd0002
          INTO TABLE g_ti_smartform
         WHERE zfactura EQ pa_fac.

  ENDMETHOD.

  METHOD send_mail.
    CONSTANTS : lc_htm TYPE char03 VALUE 'HTM'.
    DATA : lv_id        TYPE tdid VALUE 'ST',
           lv_name      TYPE tdobname VALUE 'ZFTMAIL001',
           lv_object    TYPE tdobject VALUE 'TEXT',
           lv_subject   TYPE so_obj_des,
           lv_att_title TYPE so_obj_des.
    DATA : lt_lines  TYPE TABLE OF tline,
           ls_header TYPE thead.

    mv_name = 'Nestor Javier Sánchez Sánchez'.
    mv_email = 'nestorjsan@gmail.com'.

    lv_subject = |nuevo documento { pa_fac } created|.
    "Read email template
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = lv_id
        language                = sy-langu
        name                    = lv_name
        object                  = lv_object
      IMPORTING
        header                  = ls_header
      TABLES
        lines                   = lt_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
*****Replacing variables in template*******
    "Initialize the text symbols
    CALL FUNCTION 'INIT_TEXTSYMBOL'.
    "Set dynamic text symbol
    CALL FUNCTION 'SET_TEXTSYMBOL'
      EXPORTING
        name    = '&TEXT_NAME&'
        value   = mv_name
        replace = abap_true.

    CALL FUNCTION 'SET_TEXTSYMBOL'
      EXPORTING
        name    = '&TEXT_NUMFAC&'
        value   = pa_fac
        replace = abap_true.

* DESCRIBE TABLE lt_lines LINES DATA(lv_count).
    DATA(lv_count) = lines( lt_lines ).
    "Replace text symbol in the long text
    CALL FUNCTION 'REPLACE_TEXTSYMBOL'
      EXPORTING
        endline   = lv_count
        startline = 1
      TABLES
        lines     = lt_lines.
*******************************************
* convert text to html - email body
    DATA :
      lt_html_text  TYPE TABLE OF htmlline,
      lt_body_email TYPE soli_tab.
    CALL FUNCTION 'CONVERT_ITF_TO_HTML'
      EXPORTING
        i_header       = ls_header
        i_title        = 'Título'
      TABLES
        t_itf_text     = lt_lines
        t_html_text    = lt_html_text
      EXCEPTIONS
        syntax_check   = 1
        replace        = 2
        illegal_header = 3
        OTHERS         = 4.
    lt_body_email[] = lt_html_text[].

    "Create send request
    TRY.
*************Email Subject and Body************************
        DATA(lo_send_request) = cl_bcs=>create_persistent( ).
        "Add sender to send request
        lo_send_request->set_sender( i_sender = cl_sapuser_bcs=>create( sy-uname ) ). "Email FROM.
        "Add recipient to send request
        lo_send_request->add_recipient( i_recipient = cl_cam_address_bcs=>create_internet_address( mv_email ) "Email to.
        i_express = abap_true ).
        "Email BODY
        DATA(lo_document) = cl_document_bcs=>create_document( i_type   = lc_htm
                                                              i_text = lt_body_email
                                                              i_subject = lv_subject ).
**************Email Document Attached
        "lv_att_title = |{ mv_vbeln }-{ sy-datum }.pdf|.
        lv_att_title  = |{ pa_fac }-{ sy-datum }.pdf|.
        lo_document->add_attachment( i_attachment_type = gc_format " Document Class for attachment
                                     i_attachment_subject = lv_att_title " Attachment Title
                                     i_att_content_hex = mv_pdf_content ). " Content (Binary)
        "Add document to send request
        lo_send_request->set_document( lo_document ).
        "Send email
        lo_send_request->send(
        EXPORTING
        i_with_error_screen = abap_true
        RECEIVING
        result = DATA(lv_sent_to_all) ).
        "Commit to send email
        CHECK lv_sent_to_all = abap_true.
        COMMIT WORK.

      CATCH cx_bcs INTO DATA(lo_bcs_exception). "Exception handling
        WRITE : |Type: { lo_bcs_exception->error_type } / Message { lo_bcs_exception->get_text( ) }|.

    ENDTRY.

  ENDMETHOD.

  METHOD send_mail_customer.
    me->get_customer_data( ).
    "mt_items[] = CORRESPONDING #( g_ti_smartform[] ).
    g_ti_smartform[] = CORRESPONDING #( g_ti_smartform[] ).

    me->create_pdf( ).
    me->send_mail( ).

  ENDMETHOD.
ENDCLASS.
