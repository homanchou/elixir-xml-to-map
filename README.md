# XmlToMap

**Creates an Elixir Map data structure from an XML string**

Usage:

```elixir
XmlToMap.naive_map("<foo><bar>123</bar></foo>")
```

Results in:

```elixir
%{"foo" => %{"bar" => "123"}}
```

Converts xml string to an Elixir map with strings for keys, not atoms, since atoms are not garbage collected.

This tool is inspired by Rails Hash.from_xml()

It's simple to use and doesn't require lengthy setup.  I call the function "naive", so use with caution because XML may have some structures which do not translate over to a map.   For example, naive map has no validation over what should be a collection.  If and only if nodes are repeated at the same level will they beome a list.

```elixir
# there are two points inside foo, so the value of "point" becomes a list. Had "foo" only contained one point then there would be no list but instead one nested map
XmlToMap.naive_map("<foo><point><x>1</x><y>5</y></point><point><x>2</x><y>9</y></point></foo>")

# => %{"foo" => %{"point" => [%{"x" => "1", "y" => "5"}, %{"x" => "2", "y" => "9"}]}}
```

Depends on Erlsom to parse xml then converts the 'simple_form' structure into a map.

I prefer Erlsom because it is the best documented erlang xml parser and because it mentions that it does not produce new atoms during the scanning.

See tests for example usage.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `elixir_xml_to_map` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:elixir_xml_to_map, "~> 0.1.3"}]
    end
    ```

  2. Ensure `elixir_xml_to_map` is started before your application:

    ```elixir
    def application do
      [applications: [:elixir_xml_to_map]]
    end
    ```
