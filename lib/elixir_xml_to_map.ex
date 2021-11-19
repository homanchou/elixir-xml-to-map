defmodule XmlToMap do
  @moduledoc """
  Simple convenience module for getting a map out of an XML string.
  """

  alias XmlToMap.NaiveMap

  @doc """
  `naive_map/1` utility is inspired by `Rails Hash.from_xml()` but is
  "naive" in that it is convenient (requires no setup) but carries the same
  drawbacks.

  For example no validation over what should be a collection.  If and only if
  nodes are repeated at the same level will they become a list.  If a node has
  attributes we'll prepend a "-" in front of them and merge them into the map
  and take the node value and nest that inside "#content" key.
  """
  def naive_map(xml, namespace_match_fn \\ nil) do
    tree = get_generic_data_structure(xml, namespace_match_fn)
    NaiveMap.parse(tree)
  end

  # erlsom simple_form returns a kind of tree:
  # Result = {ok, Element, Tail},
  # where Element = {Tag, Attributes, Content},
  # Tag is a string
  # Attributes = [{AttributeName, Value}],
  # Content is a list of Elements and/or strings.
  defp get_generic_data_structure(xml, nil) do
    {:ok, element, _tail} = :erlsom.simple_form(xml)
    element
  end

  defp get_generic_data_structure(xml, namespace_match_fn) do
    {:ok, element, _tail} = :erlsom.simple_form(xml, [{:nameFun, namespace_match_fn}])
    element
  end
end
