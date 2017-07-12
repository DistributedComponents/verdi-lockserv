module type IntValue = sig
  val v : int
end

module type Params = sig
  val debug : bool
  val num_clients : int
end

module LockServSerializedArrangement (P : Params) = struct
  type name = LockServSerialized.name0
  type state = LockServSerialized.data0
  type input = LockServSerialized.msg0
  type output = LockServSerialized.msg0
  type msg = Serializer_primitives.wire
  type client_id = int
  type res = (output list * state) * ((name * msg) list)
  type task_handler = name -> state -> res
  type timeout_setter = name -> state -> float option

  let systemName = "Lock Server with serialization"

  let serializeName = LockServSerializedSerialization.serializeName

  let deserializeName = LockServSerializedSerialization.deserializeName

  let init = fun n ->
    let open LockServSerialized in
    Obj.magic ((transformed_multi_params P.num_clients).init_handlers (Obj.magic n))

  let handleIO = fun n i s ->
    let open LockServSerialized in
    Obj.magic ((transformed_multi_params P.num_clients).input_handlers (Obj.magic n) (Obj.magic i) (Obj.magic s))

  let handleNet = fun dst src m s ->
    let open LockServSerialized in
    Obj.magic ((transformed_multi_params P.num_clients).net_handlers (Obj.magic dst) (Obj.magic src) (Obj.magic m) (Obj.magic s))
    
  let deserializeMsg = fun s -> Bytes.of_string s

  let serializeMsg = fun s -> Bytes.to_string s

  let deserializeInput = LockServSerializedSerialization.deserializeInput

  let serializeOutput = LockServSerializedSerialization.serializeOutput

  let debug = P.debug

  let debugInput = fun _ inp ->
    Printf.printf "[%s] got input %s" (Util.timestamp ()) (LockServSerializedSerialization.debugSerializeInput inp);
    print_newline ()

  let debugRecv = fun _ (nm, msg) ->
    Printf.printf "[%s] receiving message from %s" (Util.timestamp ()) (serializeName nm);
    print_newline ()

  let debugSend = fun _ (nm, msg) ->
    Printf.printf "[%s] sending message to %s" (Util.timestamp ()) (serializeName nm);
    print_newline ()

  let createClientId () =
    let upper_bound = 1073741823 in
    Random.int upper_bound

  let serializeClientId = string_of_int

  let timeoutTasks = []
end
