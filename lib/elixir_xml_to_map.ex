defmodule XmlToMap do

  @moduledoc """
  Simple convenience module for getting a map out of an XML string.
  """

  alias XmlToMap.NaiveMap

  @doc """
  naive_map(xml) utility is inspired by Rails Hash.from_xml()
  but is "naive" in that it is convenient (requires no setup)
  but carries the same drawbacks. Use with caution.

  XML and Maps are non-isomorphic.
  Attributes on some nodes don't carry over if the node has just
  one text value (like a leaf). Naive map has no validation over
   what should be a collection.  If and only if nodes are repeated
    at the same level will they beome a list.
  """

  def naive_map(xml) do
    #can't handle xmlns
    xml = String.replace(xml, ~r/(\sxmlns="\S+")|(xmlns:ns2="\S+")/, "")
    {:ok, tuples, _} = :erlsom.simple_form(xml)
    NaiveMap.parse(tuples)
  end

end
