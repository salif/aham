# aham

[![Package Version](https://img.shields.io/hexpm/v/aham)](https://hex.pm/packages/aham)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/aham/)

```sh
gleam add aham@1
```
```gleam
import aham
import gleam/io
import locale

// Esperanto
const messages_eo: aham.Bundle = [#("Hello", "Saluton"), #("world", "mondo")]

// Turkish
const messages_tr: aham.Bundle = [#("Hello", "Merhaba"), #("world", "dünya")]

// Bulgarian
const messages_bg: aham.Bundle = [#("Hello", "Здравей"), #("world", "свят")]

// Bulgarian Test (made-up)
const messages_bg_test: aham.Bundle = [#("Hello", "Zdravei")]

pub fn main() {
   // The examples use the Esperanto locale
   // There are two ways to use:

   // With values
   let messages =
      aham.new_with_values()
      |> aham.auto_add_bundle(locale.get_locale(), [
         #("eo", "", messages_eo),
         #("tr", "TR", messages_tr),
         #("bg", "BG", messages_bg),
         #("bg", "TEST", messages_bg_test),
      ])

   messages |> aham.get("Hello") |> io.println
   // Prints "Saluton" in Esperanto
   messages |> aham.get("Not translated yet") |> io.println
   // Prints "Not translated yet" in English

   // With keys
   let messages2 =
      aham.new_with_keys([
         #("key1", "Hello"),
         #("key2", "world"),
         #("key1000", "I am not translated"),
      ])
      |> aham.auto_add_bundle(locale.get_locale(), [
         #("eo", "", [#("key1", "Saluton"), #("key2", "mondo")]),
      ])

   messages2 |> aham.get_key("key1") |> io.println
   // Prints "Saluton" in Esperanto
   messages2 |> aham.get_key("key1000") |> io.println
   // Prints "I am not translated" in English
   messages2 |> aham.get_key("key.does.not.exist") |> io.println
   // Prints an empty string
}
```

Further documentation can be found at <https://hexdocs.pm/aham>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
