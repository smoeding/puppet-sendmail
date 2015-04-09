(*
 * Module: Test_Sendmail_List
 * Provides unit tests for the <Sendmail_List> lens.
 *
 *)

module Test_Sendmail_List =

(* Test 1: Single key *)
let t1 = "example.org\n"

test Sendmail_List.lns get t1 =
     { "key" = "example.org" }


(* Test 2: Multiple keys *)
let t2 = "example.org\n"
       . "example.com\n"

test Sendmail_List.lns get t2 =
     { "key" = "example.org" }
     { "key" = "example.com" }


(* Test 3: Empty line in the middle of file *)
let t3 = "example.org\n"
       . "\n"
       . "example.com\n"

test Sendmail_List.lns get t3 =
     { "key" = "example.org" }
     {}
     { "key" = "example.com" }


(* Test 4: Comment in the middle of file *)
let t4 = "example.org\n"
       . "# A comment\n"
       . "example.com\n"

test Sendmail_List.lns get t4 =
     { "key" = "example.org" }
     { "#comment" = "A comment" }
     { "key" = "example.com" }


(* Test 5: Comment at beginning of file *)
let t5 = "# A comment\n"
       . "example.com\n"

test Sendmail_List.lns get t5 =
     { "#comment" = "A comment" }
     { "key" = "example.com" }


(* Test 6: Comment at end of file *)
let t6 = "example.com\n"
       . "# A comment\n"

test Sendmail_List.lns get t6 =
     { "key" = "example.com" }
     { "#comment" = "A comment" }


(* Test 7: Empty file *)
let t7 = "\n"

test Sendmail_List.lns get t7 =
     { }


(* Test 8: Add first key *)
let t8 = ""

test Sendmail_List.lns put t8
after set "key [. = 'example.com']" "example.com" =
  "example.com\n"


(* Test 9: Add additional key *)
let t9 = "example.org\n"

test Sendmail_List.lns put t9
after set "key [. = 'example.com']" "example.com" =
  "example.org\n"
. "example.com\n"


(* Test 10: Add first key after comment *)
let t10 = "# A Comment\n"

test Sendmail_List.lns put t10
after set "key [. = 'example.com']" "example.com" =
  "# A Comment\n"
. "example.com\n"


(* Test 11: Add additional key after comment *)
let t11 = "example.org\n"
        . "# A Comment\n"

test Sendmail_List.lns put t11
after set "key [. = 'example.com']" "example.com" =
  "example.org\n"
. "# A Comment\n"
. "example.com\n"
