let serializeName : LockServ.name -> string = function
  | LockServ.Server -> "Server"
  | LockServ.Client i -> Printf.sprintf "Client-%d" i

let deserializeName (s : string) : LockServ.name option =
  match s with
  | "Server" -> Some LockServ.Server
  | _ -> 
    try Scanf.sscanf s "Client-%d" (fun x -> Some (LockServ.Client (Obj.magic x)))
    with _ -> None

let deserializeMsg : bytes -> LockServ.msg = fun s ->
  Marshal.from_bytes s 0

let serializeMsg : LockServ.msg -> bytes = fun m ->
  Marshal.to_bytes m []

let deserializeInput inp c : LockServ.msg option =
  match inp with
  | "Unlock" -> Some LockServ.Unlock
  | "Lock" -> Some (LockServ.Lock c)
  | "Locked" -> Some (LockServ.Locked c)
  | _ -> None

let serializeOutput : LockServ.msg -> int * string = function
  | LockServ.Lock _ -> (0, "Lock") (* never happens *)
  | LockServ.Unlock -> (0, "Unlock") (* never happens *)
  | LockServ.Locked c -> (c, "Locked")

let debugSerializeInput : LockServ.msg -> string = function
  | LockServ.Lock c -> Printf.sprintf "Lock %d" c
  | LockServ.Unlock -> "Unlock"
  | LockServ.Locked c -> Printf.sprintf "Locked %d" c

let debugSerializeMsg = debugSerializeInput
