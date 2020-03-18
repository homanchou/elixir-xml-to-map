defmodule XmlToMap do
  @moduledoc """
  Simple convenience module for getting a map out of an XML string.
  """

  alias XmlToMap.NaiveMap

  @doc """
  naive_map(xml) utility is inspired by Rails Hash.from_xml()
  but is "naive" in that it is convenient (requires no setup)
  but carries the same drawbacks.  For example no validation over
  what should be a collection.  If and only if nodes are repeated
  at the same level will they beome a list.  If a node has attributes
  we'll prepend a "-" in front of them and merge them into the map and
  take the node value and nest that inside "#content" key.
  """

  def naive_map(xml) do
    # can't handle xmlns, if left in will prepend every output map
    # key with the xmlns value in curly braces
    xml = String.replace(xml, ~r/(\sxmlns="\S+")|(xmlns:ns2="\S+")/, "")

    tree = get_generic_data_structure(xml)
    NaiveMap.parse(tree)
  end

  # erlsom simple_form returns a kind of tree:
  # Result = {ok, Element, Tail},
  # where Element = {Tag, Attributes, Content},
  # Tag is a string
  # Attributes = [{AttributeName, Value}],
  # Content is a list of Elements and/or strings.

  def get_generic_data_structure(xml) do
    {:ok, element, _tail} = :erlsom.simple_form(xml)
    element
  end
end
