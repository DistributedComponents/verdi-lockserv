open LockServ

let serializeName : name -> string = function
  | Server -> "Server"
  | Client i -> Printf.sprintf "Client-%d" i

let deserializeName : string -> name option = function
  | "Server" -> Some Server
  | try Scanf.sscanf s "Client-%d" (fun x -> Some (Client (Obj.magic x)))
    with _ -> None

let deserializeMsg : string -> msg = fun s ->
  Marshal.from_string s 0

let serializeMsg : msg -> string = fun m ->
  Marshal.to_string m []
