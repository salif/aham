import envoy
import gleam/string

pub type Locale =
   #(String, String)

/// Returns #(language code, country code), or empty strings if none is defined
pub fn get_locale() -> Locale {
   case envoy.get("LC_ALL") {
      Ok("") | Error(_) ->
         case envoy.get("LC_MESSAGES") {
            Ok("") | Error(_) ->
               case envoy.get("LANG") {
                  Ok("") | Error(_) ->
                     case envoy.get("LANGUAGE") {
                        Ok("") | Error(_) -> #("", "")
                        Ok(val) -> parse_env(val, ":")
                     }
                  Ok(val) -> parse_env(val, ".")
               }
            Ok(val) -> parse_env(val, ".")
         }
      Ok(val) -> parse_env(val, ".")
   }
}

fn parse_env(env: String, spl: String) -> Locale {
   let c_env: String = case string.split_once(env, spl) {
      Ok(#(first, _)) -> first
      Error(_) -> env
   }
   case string.split_once(c_env, "_") {
      Ok(#(first, rest)) -> #(first, rest)
      Error(_) -> #(c_env, "")
   }
}
