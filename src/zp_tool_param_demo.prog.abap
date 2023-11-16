*&---------------------------------------------------------------------*
*& Report ZP_TOOL_PARAM_DEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zp_tool_param_demo.

TYPES: BEGIN OF ts_hc,
         bukrs        TYPE bukrs,
         fktyp        TYPE RANGE OF fktyp,
         rule_ind_imp TYPE zcl_to_param=>tt_rules,
         kschl        TYPE RANGE OF kscha,
       END OF ts_hc.

DATA: ls_hc TYPE ts_hc.

zcl_to_param=>read_all_hc_program( EXPORTING iv_devid = 'ZDEMO'
                                   CHANGING cs_hc = ls_hc ).
