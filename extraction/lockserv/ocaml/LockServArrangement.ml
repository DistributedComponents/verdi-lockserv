module type IntValue = sig
  val v : int
end

module type Params = sig
  val debug : bool
  val num_clients : int
end

module LockServArrangement (P : Params) = struct
  type name = LockServ.name
  type state = LockServ.data0
  type input = LockServ.msg
  type output = LockServ.msg
  type msg = LockServ.msg
  type client_id = int
  type res = (output list * state) * ((name * msg) list)
  type task_handler = name -> state -> res
  type timeout_setter = name -> state -> float

  let systemName = "Lock Server"

  let serializeName = LockServSerialization.serializeName

  let deserializeName = LockServSerialization.deserializeName

  let init = fun n ->
    let open LockServ in
    Obj.magic ((lockServ_MultiParams P.num_clients).init_handlers (Obj.magic n))

  let handleIO = fun n i s ->
    let open LockServ in
    Obj.magic ((lockServ_MultiParams P.num_clients).input_handlers (Obj.magic n) (Obj.magic i) (Obj.magic s))

  let handleNet = fun dst src m s ->
    let open LockServ in
    Obj.magic ((lockServ_MultiParams P.num_clients).net_handlers (Obj.magic dst) (Obj.magic src) (Obj.magic m) (Obj.magic s))
    
  let deserializeMsg = LockServSerialization.deserializeMsg

  let serializeMsg = LockServSerialization.serializeMsg

  let deserializeInput = LockServSerialization.deserializeInput

  let serializeOutput = LockServSerialization.serializeOutput

  let debug = P.debug

  let debugInput = fun _ inp ->
    Printf.printf "[%s] got input %s" (Util.timestamp ()) (LockServSerialization.debugSerializeInput inp);
    print_newline ()

  let debugRecv = fun _ (nm, msg) ->
    Printf.printf "[%s] receiving message %s from %s" (Util.timestamp ()) (LockServSerialization.debugSerializeMsg msg) (serializeName nm);
    print_newline ()

  let debugSend = fun _ (nm, msg) ->
    Printf.printf "[%s] sending message %s to %s" (Util.timestamp ()) (LockServSerialization.debugSerializeMsg msg) (serializeName nm);
    print_newline ()

  let createClientId () =
    let upper_bound = 1073741823 in
    Random.int upper_bound

  let serializeClientId = string_of_int

  let timeoutTasks = []
end
