defmodule XmlToMap.NestedMap do
  @moduledoc """
  Module to recursively traverse the output of `erlsom.simple_form/1`
  and produce a nested map with `name`, `attributes`, and `content` fields.

  `erlsom` uses character lists so this library converts them to
  Elixir binary string.
  """

  # if a single list element of a tuple, ignore the list detail and parse it
  def parse([{tag, attributes, content}]) do
    parse({tag, attributes, content})
  end

  # for any other singular value, it's probably meant to be a string
  def parse([value]) do
    value |> to_string() |> String.trim()
  end

  # a parse with a tuples is probably the entry point we'll hit first
  # if this node has no attributes, our work is easier
  def parse({tag, attributes, content}) do
    %{name: to_string(tag), attributes: attributes, content: parse(content)}
  end

  def parse([]), do: nil

  def parse(list) when is_list(list), do: Enum.map(list, &parse/1)
end
