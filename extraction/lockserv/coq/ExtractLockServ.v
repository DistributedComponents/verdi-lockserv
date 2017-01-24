Require Import Verdi.Verdi.
Require Import Verdi.LockServ.

Require Import ExtrOcamlBasic.
Require Import ExtrOcamlNatInt.

Require Import Verdi.ExtrOcamlBasicExt.
Require Import Verdi.ExtrOcamlNatIntExt.

Require Import Verdi.ExtrOcamlList.
Require Import Verdi.ExtrOcamlFin.

Extraction "extraction/lockserv/ocaml/LockServ.ml" seq LockServ_BaseParams LockServ_MultiParams.
