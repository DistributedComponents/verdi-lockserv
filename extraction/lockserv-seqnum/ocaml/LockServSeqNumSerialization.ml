let serializeName : LockServSeqNum.name0 -> string = function
  | LockServSeqNum.Server -> "Server"
  | LockServSeqNum.Client i -> Printf.sprintf "Client-%d" i

let deserializeName (s : string) : LockServSeqNum.name0 option =
  match s with
  | "Server" -> Some LockServSeqNum.Server
  | _ -> 
    try Scanf.sscanf s "Client-%d" (fun x -> Some (LockServSeqNum.Client (Obj.magic x)))
    with _ -> None

let deserializeMsg : string -> LockServSeqNum.seq_num_msg = fun s ->
  Marshal.from_string s 0

let serializeMsg : LockServSeqNum.seq_num_msg -> string = fun m ->
  Marshal.to_string m []

let deserializeInput inp c : LockServSeqNum.msg0 option =
  match inp with
  | "Unlock" -> Some LockServSeqNum.Unlock
  | "Lock" -> Some (LockServSeqNum.Lock c)
  | "Locked" -> Some (LockServSeqNum.Locked c)
  | _ -> None

let serializeOutput : LockServSeqNum.msg0 -> int * string = function
  | LockServSeqNum.Lock _ -> (0, "Lock") (* never happens *)
  | LockServSeqNum.Unlock -> (0, "Unlock") (* never happens *)
  | LockServSeqNum.Locked c -> (c, "Locked")

let debugSerializeInput : LockServSeqNum.msg0 -> string = function
  | LockServSeqNum.Lock c -> Printf.sprintf "Lock %d" c
  | LockServSeqNum.Unlock -> "Unlock"
  | LockServSeqNum.Locked c -> Printf.sprintf "Locked %d" c

let debugSerializeMsg : LockServSeqNum.seq_num_msg -> string = function
  | { LockServSeqNum.tmNum = n ; LockServSeqNum.tmMsg = m } ->
    Printf.sprintf "%d: %s" n (debugSerializeInput (Obj.magic m))
