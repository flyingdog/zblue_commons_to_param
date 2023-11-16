CLASS zcl_to_messages DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS check_error
      IMPORTING
        it_return       TYPE bapiret2_t
      RETURNING
        VALUE(rv_error) TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_to_messages IMPLEMENTATION.

  METHOD check_error.

    CLEAR rv_error.

    IF it_return IS INITIAL. RETURN. ENDIF.

    LOOP AT it_return TRANSPORTING NO FIELDS WHERE type CA 'AEX'.

      rv_error = abap_true.

      EXIT.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
