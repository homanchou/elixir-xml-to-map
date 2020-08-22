defmodule XmlToMap.NaiveMap do
  @moduledoc """
  Module to recursively traverse the output of erlsom.simple_form
  and produce a map.

  erlsom uses character lists so this library converts them to
  Elixir binary string.

  Attributes, if present, are defined as tag@attribute_name => attribute_value
  """

  # if a single list element of a tuple, ignore the list detail and parse it
  def parse([{tag, attributes, content}]) do
    parse({tag, attributes, content})
  end

  # for any other singular value, it's probably meant to be a string
  def parse([value]) do
    to_string(value) |> String.trim()
  end

  # a parse with a tuples is probably the entry point we'll hit first
  # if this node has no attributes, our work is easier
  def parse({tag, [], content}) do
    parsed_content = parse(content)
    %{to_string(tag) => parsed_content}
  end

  # this is probably the entry point we'll hit first
  # Element = {Tag, Attributes, Content},
  # Tag is a string
  # Attributes = [{AttributeName, Value}],
  # Content is a list of Elements and/or strings.
  # in this case attributes is not empty
  def parse({tag, attributes, content}) do
    attributes_map =
      Enum.reduce(attributes, %{}, fn {attribute_name, attribute_value}, acc ->
        Map.put(acc, "-#{attribute_name}", to_string(attribute_value))
      end)

    parsed_content = parse(content)
    joined_content = %{"#content" => parsed_content} |> Map.merge(attributes_map)

    %{to_string(tag) => joined_content}
  end

  def parse(list) when is_list(list) do
    parsed_list = Enum.map(list, &{to_string(elem(&1, 0)), parse(&1)})

    content =
      Enum.reduce(parsed_list, %{}, fn {k, v}, acc ->
        case Map.get(acc, k) do
          nil ->
            for({key, value} <- v, into: %{}, do: {key, value})
            |> Map.merge(acc)

          [h | t] ->
            Map.put(acc, k, [h | t] ++ [v[k]])

          prev ->
            Map.put(acc, k, [prev] ++ [v[k]])
        end
      end)

    case content == %{} do
      true -> nil
      _ -> content
    end
  end
end
