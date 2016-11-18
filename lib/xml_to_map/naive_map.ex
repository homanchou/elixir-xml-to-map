defmodule XmlToMap.NaiveMap do

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
        %{to_string(name) => parsed_content}
    end
  end

  def parse([{name, _, _}, {name, _, _} | _] = list) do
    %{to_string(name) => Enum.map(list, fn {_,_,c} -> parse(c) end)}
  end

  def parse([_first, _second | _] = list) do
    Enum.reduce list, %{}, fn tuple, acc -> 
      Map.merge(acc, parse(tuple)) 
    end
  end

  defp attr_map(list) do
    list |> Enum.map(fn {k,v} -> {to_string(k), to_string(v)} end) |> Map.new
  end


end