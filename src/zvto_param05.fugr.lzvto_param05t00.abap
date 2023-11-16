*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVTO_PARAM05....................................*
TABLES: ZVTO_PARAM05, *ZVTO_PARAM05. "view work areas
CONTROLS: TCTRL_ZVTO_PARAM05
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVTO_PARAM05. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVTO_PARAM05.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVTO_PARAM05_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVTO_PARAM05.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTO_PARAM05_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVTO_PARAM05_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVTO_PARAM05.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTO_PARAM05_TOTAL.

*.........table declarations:.................................*
TABLES: ZTO_PARAM02                    .
