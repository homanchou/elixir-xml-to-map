defmodule XmlToMap do
  
  alias XmlToMap.NaiveMap

  def naive_map(xml) do
    {:ok, tuples, _} = :erlsom.simple_form(xml)
    NaiveMap.parse(tuples)
  end

end
