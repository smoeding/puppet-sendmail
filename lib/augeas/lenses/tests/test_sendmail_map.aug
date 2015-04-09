(*
 * Module: Test_Sendmail_Map
 * Provides unit tests for the <Sendmail_Map> lens.
 *
 *)

module Test_Sendmail_Map =

(* Test 1: Single key *)
let t1 = "example.org RELAY\n"

test Sendmail_Map.lns get t1 =
     { "key" = "example.org" { "value" = "RELAY" } }


(* Test 2: Multiple keys *)
let t2 = "example.org RELAY\n"
       . "example.com RELAY \n"

test Sendmail_Map.lns get t2 =
     { "key" = "example.org" { "value" = "RELAY" } }
     { "key" = "example.com" { "value" = "RELAY" } }
