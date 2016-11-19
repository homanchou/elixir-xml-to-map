defmodule XmlToMap do
  
  alias XmlToMap.NaiveMap

  def naive_map(xml) do
    #can't handle xmlns
    xml = String.replace(xml, ~r/\sxmlns=\".*\"/, "")
    {:ok, tuples, _} = :erlsom.simple_form(xml)
    NaiveMap.parse(tuples)
  end

end
