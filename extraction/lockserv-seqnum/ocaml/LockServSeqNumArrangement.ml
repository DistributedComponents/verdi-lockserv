module type IntValue = sig
  val v : int
end

module type Params = sig
  val debug : bool
  val num_clients : int
end

module LockServSeqNumArrangement (P : Params) = struct
  type name = LockServSeqNum.name0
  type state = LockServSeqNum.seq_num_data
  type input = LockServSeqNum.msg0
  type output = LockServSeqNum.msg0
  type msg = LockServSeqNum.seq_num_msg
  type client_id = int
  type res = (output list * state) * ((name * msg) list)
  type task_handler = name -> state -> res
  type timeout_setter = name -> state -> float

  let systemName = "Lock Server with Sequence Numbering"

  let serializeName = LockServSeqNumSerialization.serializeName

  let deserializeName = LockServSeqNumSerialization.deserializeName

  let init = fun n ->
    let open LockServSeqNum in
    Obj.magic ((transformed_multi_params P.num_clients).init_handlers (Obj.magic n))

  let handleIO = fun n i s ->
    let open LockServSeqNum in
    Obj.magic ((transformed_multi_params P.num_clients).input_handlers (Obj.magic n) (Obj.magic i) (Obj.magic s))

  let handleNet = fun dst src m s ->
    let open LockServSeqNum in
    Obj.magic ((transformed_multi_params P.num_clients).net_handlers (Obj.magic dst) (Obj.magic src) (Obj.magic m) (Obj.magic s))
    
  let deserializeMsg = LockServSeqNumSerialization.deserializeMsg

  let serializeMsg = LockServSeqNumSerialization.serializeMsg

  let deserializeInput = LockServSeqNumSerialization.deserializeInput

  let serializeOutput = LockServSeqNumSerialization.serializeOutput

  let debug = P.debug

  let debugInput = fun _ inp ->
    Printf.printf "[%s] got input %s" (Util.timestamp ()) (LockServSeqNumSerialization.debugSerializeInput inp);
    print_newline ()

  let debugRecv = fun _ (nm, msg) ->
    Printf.printf "[%s] receiving message %s from %s" (Util.timestamp ()) (LockServSeqNumSerialization.debugSerializeMsg msg) (serializeName nm);
    print_newline ()

  let debugSend = fun _ (nm, msg) ->
    Printf.printf "[%s] sending message %s to %s" (Util.timestamp ()) (LockServSeqNumSerialization.debugSerializeMsg msg) (serializeName nm);
    print_newline ()

  let createClientId () =
    let upper_bound = 1073741823 in
    Random.int upper_bound

  let serializeClientId = string_of_int

  let timeoutTasks = []
end
