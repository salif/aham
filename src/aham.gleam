import gleam/dict
import gleam/list
import locale

pub type Aham =
   dict.Dict(String, String)

pub type Bundle =
   List(#(String, String))

/// Use with `aham.get_key`
pub fn new_with_keys(bundle: Bundle) -> Aham {
   dict.from_list(bundle)
}

/// Use with `aham.get`
pub fn new_with_values() -> Aham {
   dict.new()
}

pub fn auto_add_bundle(
   a: Aham,
   user_locale: locale.Locale,
   bundles: List(#(String, String, Bundle)),
) -> Aham {
   case list.filter(bundles, fn(key_lang) { key_lang.0 == user_locale.0 }) {
      // don't add bundle
      [] -> a
      [b] -> add_bundle(a, b.2)
      bs ->
         case list.filter(bs, fn(key_country) { key_country.1 == user_locale.1 }) {
            [] ->
               case list.first(bs) {
                  Ok(bl) -> add_bundle(a, bl.2)
                  // This should not happen, bs is not []
                  Error(Nil) -> a
               }
            [bl] -> add_bundle(a, bl.2)
            // duplicates
            [bl, ..] -> add_bundle(a, bl.2)
         }
   }
}

pub fn add_bundle(a: Aham, bundle: Bundle) -> Aham {
   case dict.size(a) == 0 {
      True -> dict.from_list(bundle)
      False -> dict.merge(a, dict.from_list(bundle))
   }
}

/// Returns translation or `str` as a fallback
pub fn get(a: Aham, str: String) -> String {
   case dict.get(a, str) {
      Ok(v) -> v
      Error(_) -> str
   }
}

/// Returns translation or empty string as a fallback
pub fn get_key(a: Aham, key: String) -> String {
   case dict.get(a, key) {
      Ok(v) -> v
      Error(_) -> ""
   }
}
