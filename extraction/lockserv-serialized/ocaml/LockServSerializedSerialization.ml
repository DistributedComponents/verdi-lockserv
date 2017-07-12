let serializeName : LockServSerialized.name0 -> string = function
  | LockServSerialized.Server -> "Server"
  | LockServSerialized.Client i -> Printf.sprintf "Client-%d" i

let deserializeName (s : string) : LockServSerialized.name0 option =
  match s with
  | "Server" -> Some LockServSerialized.Server
  | _ -> 
    try Scanf.sscanf s "Client-%d" (fun x -> Some (LockServSerialized.Client (Obj.magic x)))
    with _ -> None

(* run after receiving from client socket *)
let deserializeInput inp c : LockServSerialized.msg0 option =
  match inp with
  | "Unlock" -> Some LockServSerialized.Unlock
  | "Lock" -> Some (LockServSerialized.Lock c)
  | "Locked" -> Some (LockServSerialized.Locked c)
  | _ -> None

(* received from handler, sent to client *)
let serializeOutput : LockServSerialized.msg0 -> int * string = function
  | LockServSerialized.Lock _ -> (0, "Lock") (* never happens *)
  | LockServSerialized.Unlock -> (0, "Unlock") (* never happens *)
  | LockServSerialized.Locked c -> (c, "Locked")

let debugSerializeInput : LockServSerialized.msg0 -> string = function
  | LockServSerialized.Lock c -> Printf.sprintf "Lock %d" c
  | LockServSerialized.Unlock -> "Unlock"
  | LockServSerialized.Locked c -> Printf.sprintf "Locked %d" c
