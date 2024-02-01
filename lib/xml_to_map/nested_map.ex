defmodule XmlToMap.NestedMap do
  @moduledoc """
  Module to recursively traverse the output of `erlsom.simple_form/1`
  and produce a nested map with `name`, `attributes`, and `content` fields.

  `erlsom` uses character lists so this library converts them to
  Elixir binary string.
  """

  @moduledoc since: "3.1.0"

  @typedoc "Type of a nested map"
  @type element :: %{
          name: String.t(),
          attributes: map() | [{charlist() | String.t(), charlist() | String.t()}],
          content: [element()]
        }

  # if a single list element of a tuple, ignore the list detail and parse it
  def parse([{tag, attributes, content}], purge_empty) do
    parse({tag, attributes, content}, purge_empty)
  end

  # for any other singular value, it's probably meant to be a string
  def parse([value], _purge_empty) do
    value |> to_string() |> String.trim()
  end

  # a parse with a tuples is probably the entry point we'll hit first
  # if this node has no attributes, our work is easier
  def parse({tag, [], []}, true) do
    %{name: to_string(tag)}
  end

  def parse({tag, [], content}, true) do
    %{name: to_string(tag), content: parse(content, true)}
  end

  def parse({tag, attributes, []}, true) do
    %{name: to_string(tag), attributes: fix_attributes(attributes)}
  end

  def parse({tag, attributes, content}, purge_empty) do
    %{
      name: to_string(tag),
      attributes: fix_attributes(attributes),
      content: parse(content, purge_empty)
    }
  end

  def parse([], _purge_empty), do: nil

  def parse(list, purge_empty) when is_list(list), do: Enum.map(list, &parse(&1, purge_empty))

  defp fix_attributes(attributes) do
    for {k, v} <- attributes do
      k = if is_list(k) and List.ascii_printable?(k), do: to_string(k), else: k
      v = if is_list(v) and List.ascii_printable?(v), do: to_string(v), else: v
      {k, v}
    end
  end
end
