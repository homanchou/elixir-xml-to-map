# XmlToMap

[![Module Version](https://img.shields.io/hexpm/v/elixir_xml_to_map.svg)](https://hex.pm/packages/elixir_xml_to_map)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/elixir_xml_to_map/)
[![Total Download](https://img.shields.io/hexpm/dt/elixir_xml_to_map.svg)](https://hex.pm/packages/elixir_xml_to_map)
[![License](https://img.shields.io/hexpm/l/elixir_xml_to_map.svg)](https://github.com/homanchou/elixir_xml_to_map/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/homanchou/elixir-xml-to-map.svg)](https://github.com/homanchou/elixir-xml-to-map/commits/master)

Creates an Elixir Map data structure from an XML string.

Usage:

```elixir
XmlToMap.naive_map("<foo><bar>123</bar></foo>")
```

Results in:

```elixir
%{"foo" => %{"bar" => "123"}}
```

Converts XML string to an Elixir map with strings for keys, not atoms, since atoms are not garbage collected.

This tool is inspired by Rails `Hash.from_xml()`.

----

I call the function "naive", because there are known short comings and there is some [controversy](https://stackoverflow.com/questions/40650482/how-to-convert-xml-to-a-map-in-elixir) around using a conversion tool like this since XML and Maps are non-isomorphic and there is no standard way to convert all the information from one format to another.  The recommended way to pull specific well structured information from XML is to use something like xpath.  But if you understand the risks and still prefer to convert the whole XML string to a map then this tool is for you!

It is currently not able to parse XML namespace.  It also can't determine if a child should be a list unless it sees a repeated child.  If and only if nodes are repeated at the same level will they become a list.

```elixir
# there are two points inside foo, so the value of "point" becomes a list. Had "foo" only contained one point then there would be no list but instead one nested map
XmlToMap.naive_map("<foo><point><x>1</x><y>5</y></point><point><x>2</x><y>9</y></point></foo>")

# => %{"foo" => %{"point" => [%{"x" => "1", "y" => "5"}, %{"x" => "2", "y" => "9"}]}}
```

Previously this package did not handle XML node attributes.
The current version takes inspiration from a [go goxml2json package](https://github.com/basgys/goxml2json) and exports attributes in the map while prepending "-" so you know they are attributes.

Whenever we encounter an XML node with BOTH attributes and children, we wrap "#content" around the node's inner value.

For example this snippet has a `Height` leaf node with attribute `Units` and a value of `0.50`:

```xml
<ItemDimensions>
   <Height Units="inches">0.50</Height>
</ItemDimensions>
```

This would become this snippet:

```json
...
"ItemDimensions": {
     "Height": {
           "#content": "0.50",
           "-Units": "inches"
     }
}
```

Empty tags will have a value of nil.

-----

There is a dependency on Erlsom to parse XML then converts the 'simple_form' structure into a map.

I prefer Erlsom because it is the best documented erlang XML parser and because it mentions that it does not produce new atoms during the scanning.

See tests for some example usage.

----

## Installation

The package can be installed as:

1.  Add `:elixir_xml_to_map` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:elixir_xml_to_map, "~> 2.0"}]
    end
    ```

2.  Ensure `:elixir_xml_to_map` is started before your application:

    ```elixir
    def application do
      [applications: [:elixir_xml_to_map]]
    end
    ```


## License

Copyright (c) 2016-present, Homan Chou

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
