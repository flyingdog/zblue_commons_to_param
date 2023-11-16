CLASS zcl_to_param DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ts_rule,
        numer  TYPE drf_lfdnr,
        valwh  TYPE z_param_val_when,
        valth  TYPE z_param_val_then,
        valth2 TYPE z_param_val_then2,
      END OF ts_rule .
    TYPES:
      BEGIN OF ts_hc,
        param   TYPE fieldname,
        sysname TYPE zhc_system_name,
        rolnm   TYPE rollname,
        party   TYPE zparam_type,
        sign    TYPE ddsign,
        optio   TYPE ddoption,
        valow   TYPE z_param_value,
        valhg   TYPE z_param_value.
        INCLUDE TYPE ts_rule.
    TYPES: END OF ts_hc .
    TYPES:
      BEGIN OF ts_mult_hc,
        param    TYPE fieldname,
        variable TYPE REF TO data,
      END OF ts_mult_hc .
    TYPES:
      tt_hc      TYPE STANDARD TABLE OF ts_hc .
    TYPES:
      tt_mult_hc TYPE STANDARD TABLE OF ts_mult_hc .
    TYPES:
      tt_rules  TYPE STANDARD TABLE OF ts_rule WITH EMPTY KEY .

    CONSTANTS gc_parameter TYPE zparam_type VALUE 'P' ##NO_TEXT.
    CONSTANTS gc_select_opt TYPE zparam_type VALUE 'S' ##NO_TEXT.
    CONSTANTS gc_rule TYPE zparam_type VALUE 'R' ##NO_TEXT.

    CLASS-METHODS read_all_hc_program
      IMPORTING
        !iv_devid TYPE zdev_id
      CHANGING
        !cs_hc    TYPE any .
    CLASS-METHODS reference_struct_hc
      CHANGING
        !cs_hc      TYPE any
        !ct_mult_hc TYPE tt_mult_hc .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-METHODS get_single_hard_code_val
      IMPORTING
        !it_hc      TYPE tt_hc
        !iv_param   TYPE fieldname
        !iv_sysname TYPE zhc_system_name
      EXPORTING
        !et_param   TYPE STANDARD TABLE
        !ev_param   TYPE any
        !et_rules   TYPE tt_rules .

    CLASS-METHODS select_hc
      IMPORTING
        !iv_devid TYPE zdev_id
      EXPORTING
        !et_hc    TYPE tt_hc .
ENDCLASS.



CLASS zcl_to_param IMPLEMENTATION.


  METHOD get_single_hard_code_val.

    DATA: lr_param TYPE RANGE OF z_param_value.

    IF iv_param IS INITIAL. RETURN. ENDIF.

    READ TABLE it_hc ASSIGNING FIELD-SYMBOL(<ls_hc>) BINARY SEARCH
      WITH KEY param    = iv_param
               sysname  = iv_sysname.

    IF sy-subrc <> 0. RETURN. ENDIF.

    DATA(lv_tabix) = sy-tabix.

    CASE <ls_hc>-party.
      WHEN gc_select_opt.

        LOOP AT it_hc ASSIGNING <ls_hc> FROM lv_tabix.
          IF <ls_hc>-param <> iv_param OR
             <ls_hc>-sysname <> iv_sysname.
            EXIT.
          ENDIF.

          APPEND INITIAL LINE TO lr_param ASSIGNING FIELD-SYMBOL(<lr_param>).

          <lr_param> = VALUE #( sign    = <ls_hc>-sign
                                option  = <ls_hc>-optio
                                low     = <ls_hc>-valow
                                high    = <ls_hc>-valhg ).

          APPEND INITIAL LINE TO et_param ASSIGNING FIELD-SYMBOL(<ls_param>).
          <ls_param> = CORRESPONDING #( <lr_param> ).
        ENDLOOP.

        SORT et_param BY ('SIGN') ('OPTION') ('LOW') ('HIGH').

      WHEN gc_parameter.

        ev_param = <ls_hc>-valow.

      WHEN gc_rule.

        LOOP AT it_hc ASSIGNING <ls_hc> FROM lv_tabix.
          IF <ls_hc>-param <> iv_param OR
             <ls_hc>-sysname <> iv_sysname.
            EXIT.
          ENDIF.

          APPEND CORRESPONDING #( <ls_hc> ) TO et_rules.

        ENDLOOP.

        SORT et_rules BY numer.

      WHEN OTHERS.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD read_all_hc_program.

    DATA: lt_mult_hc TYPE tt_mult_hc,
          lv_sysname TYPE zhc_system_name.

    FIELD-SYMBOLS: <lt_range>  TYPE STANDARD TABLE,
                   <lv_any>    TYPE any,
                   <lt_reglas> TYPE tt_rules.

    DESCRIBE FIELD cs_hc TYPE DATA(lv_type).

    " Only structure type: plain and deep
    IF lv_type <> cl_abap_typedescr=>typekind_struct1 AND
       lv_type <> cl_abap_typedescr=>typekind_struct2.

      RETURN.
    ENDIF.

    " Read all structure fields
    DATA(lo_struct) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( cs_hc ) ).

    LOOP AT lo_struct->get_components( ) ASSIGNING FIELD-SYMBOL(<ls_cmp>).

      " Save the reference of the structure component
      ASSIGN COMPONENT <ls_cmp>-name OF STRUCTURE cs_hc TO FIELD-SYMBOL(<ls_value>).

      APPEND VALUE #( param     = <ls_cmp>-name
                      variable  = REF #( <ls_value> ) ) TO lt_mult_hc.

    ENDLOOP.

    select_hc( EXPORTING iv_devid = iv_devid
               IMPORTING et_hc = DATA(lt_hc) ).

    IF lt_hc IS INITIAL. RETURN. ENDIF.

    LOOP AT lt_mult_hc ASSIGNING FIELD-SYMBOL(<ls_mult_hc>).

      CLEAR lv_sysname.

      READ TABLE lt_hc ASSIGNING FIELD-SYMBOL(<ls_hc>) BINARY SEARCH
        WITH KEY param      = <ls_mult_hc>-param
                 sysname    = sy-sysid.

      IF sy-subrc <> 0.
        READ TABLE lt_hc ASSIGNING <ls_hc> BINARY SEARCH
          WITH KEY param      = <ls_mult_hc>-param
                   sysname    = abap_false.
      ELSE.
        lv_sysname = sy-sysid.
      ENDIF.

      CHECK sy-subrc = 0.

      CASE <ls_hc>-party.
        WHEN gc_parameter.

          ASSIGN <ls_mult_hc>-variable->* TO <lv_any>.

          get_single_hard_code_val( EXPORTING it_hc         = lt_hc
                                              iv_param      = <ls_mult_hc>-param
                                              iv_sysname    = lv_sysname
                                    IMPORTING ev_param = <lv_any> ).
        WHEN gc_select_opt.

          ASSIGN <ls_mult_hc>-variable->* TO <lt_range>.

          get_single_hard_code_val( EXPORTING it_hc         = lt_hc
                                              iv_param      = <ls_mult_hc>-param
                                              iv_sysname    = lv_sysname
                                    IMPORTING et_param = <lt_range> ).

        WHEN gc_rule.

          ASSIGN <ls_mult_hc>-variable->* TO <lt_reglas>.

          get_single_hard_code_val( EXPORTING it_hc         = lt_hc
                                              iv_param      = <ls_mult_hc>-param
                                              iv_sysname    = lv_sysname
                                     IMPORTING et_rules = <lt_reglas> ).
        WHEN OTHERS.
          CONTINUE.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.


  METHOD reference_struct_hc.

    DESCRIBE FIELD cs_hc TYPE DATA(lv_type).

    " Only structure type: plain and deep
    IF lv_type <> cl_abap_typedescr=>typekind_struct1 AND
       lv_type <> cl_abap_typedescr=>typekind_struct2.

      RETURN.
    ENDIF.

    " Read all structure fields
    DATA(lo_struct) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( cs_hc ) ).

    " Iterate above all components of the structure
    LOOP AT lo_struct->get_components( ) ASSIGNING FIELD-SYMBOL(<ls_cmp>).

      " Save the reference of the structure component
      ASSIGN COMPONENT <ls_cmp>-name OF STRUCTURE cs_hc TO FIELD-SYMBOL(<ls_value>).

      ct_mult_hc = VALUE #( BASE ct_mult_hc ( param     = <ls_cmp>-name
                                              variable  = REF #( <ls_value> ) ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD select_hc.

    DATA: lt_filter_pos TYPE STANDARD TABLE OF fieldname,
          lt_filter_reg TYPE STANDARD TABLE OF fieldname.

    IF iv_devid IS INITIAL. RETURN. ENDIF.

    SELECT head~param, head~sysname, head~rolnm, head~party,
           item~sign, item~optio, item~valow, item~valhg
      FROM zto_param01 AS head
      JOIN zto_param02 AS item ON item~devid = head~devid AND item~param = head~param AND
                                  item~sysname = head~sysname
      INTO TABLE @et_hc
      WHERE head~devid = @iv_devid AND
            head~party IN ( @gc_parameter, @gc_select_opt ).

    SELECT head~param, head~sysname, head~rolnm, head~party,
           @abap_false AS sign, @abap_false AS optio, @abap_false AS valow, @abap_false AS valhg,
           rule~numer, rule~valwh, rule~valth, rule~valth2
      FROM zto_param01 AS head
      JOIN zto_param03 AS rule ON rule~devid = head~devid AND rule~param = head~param AND
                                  rule~sysname = head~sysname
      APPENDING TABLE @et_hc
      WHERE head~devid = @iv_devid AND
            head~party = @gc_rule.

    SORT et_hc BY param sysname.

  ENDMETHOD.
ENDCLASS.
