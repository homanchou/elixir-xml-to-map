defmodule XmlToMap.NaiveMap do

  @moduledoc """
  Module to recursively traverse the output of erlsom.simple_form
  and produce a map.

  erlsom uses character lists so this library converts them to
  Elixir binary string.
  """

  def parse([value]) do
    case is_tuple(value) do
      true -> parse(value)
      false -> to_string(value) |> String.trim
    end
  end

  def parse({name, attr, content}) do
    parsed_content = parse(content)
    case is_map(parsed_content) do
      true ->
        %{to_string(name) => parsed_content |> Map.merge(attr_map(attr))}
      false ->
        %{to_string(name) => (if attr_map(attr) == %{} do
          parsed_content
        else
          attr |> attr_map() |> Map.put_new(to_string(name), parsed_content)
        end)}
    end
  end

  def parse(list) when is_list(list) do
    parsed_list = Enum.map list, &({to_string(elem(&1,0)), parse(&1)})
    Enum.reduce parsed_list, %{}, fn {k,v}, acc ->
      case Map.get(acc, k) do
        nil -> Map.put_new(acc, k, v[k])
        [h|t] -> Map.put(acc, k, [h|t] ++ [v[k]])
        prev -> Map.put(acc, k, [prev] ++ [v[k]])
      end
    end
  end

  defp attr_map(list) do
    list |> Enum.map(fn {k,v} -> {to_string(k), to_string(v)} end) |> Map.new
  end
end
