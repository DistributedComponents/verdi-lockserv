Require Import Verdi.Verdi.

Require Import Cheerios.Core.
Require Import Cheerios.Types.
Require Import Cheerios.BasicSerializers.

Require Import LockServSerialized.

Require Import ExtrOcamlBasic.
Require Import ExtrOcamlNatInt.
Require Import ExtrOcamlString.

Require Import Verdi.ExtrOcamlBasicExt.
Require Import Verdi.ExtrOcamlList.
Require Import Verdi.ExtrOcamlFin.

Require Import Cheerios.ExtrCheerios.

Extract Inlined Constant nat_serialize => "(fun i -> Serializer_primitives.putInt (Int32.of_int i))".

Extract Inlined Constant nat_deserialize => "(Serializer_primitives.map Int32.to_int Serializer_primitives.getInt)".

Extraction "extraction/lockserv-serialized/ocaml/LockServSerialized.ml" seq transformed_base_params transformed_multi_params.
