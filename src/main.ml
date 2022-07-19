let req1 = 
  let open Lwt.Syntax in
    let url = Uri.of_string "http://localhost:8080/servico-a/cotacao?moeda=USD" in
    let* (_res, body)= Cohttp_lwt_unix.Client.get url in
    Cohttp_lwt.Body.to_string body


let req2 = 
  let open Lwt.Syntax in
    let url = Uri.of_string "http://localhost:8080/servico-b/cotacao?curr=USD" in
    let* (_res, body)= Cohttp_lwt_unix.Client.get url in
    Cohttp_lwt.Body.to_string body

let req3 = 
  let open Lwt.Syntax in
    let url = Uri.of_string "http://localhost:8080/servico-c/cotacao" in
    let body = `Assoc [
      "tipo", `String "USD";
      "callback", `String "http://127.0.0.1:3001/service-c";
      "cid", `String "74d3fb63-5621-46fd-85d1-56e4e9c04a3a"
    ] |> Yojson.to_string |> Cohttp_lwt.Body.of_string in
    let* (_res, body)= Cohttp_lwt_unix.Client.post ~body url in
    Cohttp_lwt.Body.to_string body


(*   let () =  *)
(*     print_endline @@ *)
(*     Lwt_main.run @@  *)
(*     req3 *)
(*     (* Lwt.pick [req1; req2] *) *)


(*  *)


open Lwt.Infix

let () = Dream.run ~port:4000
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ -> 
      req1 >|= Dream.response 
    );
    Dream.get "/servico-c/cotacao" (fun _ -> Dream.empty `OK)
  ]

