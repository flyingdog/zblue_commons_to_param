*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVTO_PARAM01....................................*
TABLES: ZVTO_PARAM01, *ZVTO_PARAM01. "view work areas
CONTROLS: TCTRL_ZVTO_PARAM01
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVTO_PARAM01. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVTO_PARAM01.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVTO_PARAM01_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVTO_PARAM01.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTO_PARAM01_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVTO_PARAM01_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVTO_PARAM01.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTO_PARAM01_TOTAL.

*.........table declarations:.................................*
TABLES: ZTO_PARAM01                    .
