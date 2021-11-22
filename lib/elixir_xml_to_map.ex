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
  def naive_map(xml, opts \\ %{}) do
    tree = get_generic_data_structure(xml, opts)
    NaiveMap.parse(tree)
  end

  # Default function to handle namespace in xml
  # This fuction invokes an anonymous function that has this parameters: Name, Namespace, Prefix.
  # Usually, the namespace appears at the top of xml file, e.g `xmlns:g="http://base.google.com/ns/1.0"`,
  # where `g` is the Prefix and `"http://base.google.com/ns/1.0"` the Namespace,
  # the Name is the key tag in xml.
  # It should return a term. It is called for each tag and attribute name.
  # The result will be used in the output.
  # When a namespace and prefix is found, it'll return a term like "#{prefix}:#{name}",
  # otherwise it will return only the name.
  # The default behavior in :erlsom.simple_form/2 is Name if Namespace == undefined, and a string {Namespace}Name otherwise.
  def default_namespace_match_fn do
    fn(name, namespace, prefix) ->
      cond do
        namespace != [] && prefix != [] -> "#{prefix}:#{name}"
        true -> name
      end
    end
  end

  defp get_generic_data_structure(xml, %{namespace_match_fn: namespace_match_fn} = opts) do
    {:ok, element, _tail} = :erlsom.simple_form(xml, [{:nameFun, namespace_match_fn}])
    element
  end

  # erlsom simple_form returns a kind of tree:
  # Result = {ok, Element, Tail},
  # where Element = {Tag, Attributes, Content},
  # Tag is a string
  # Attributes = [{AttributeName, Value}],
  # Content is a list of Elements and/or strings.
  defp get_generic_data_structure(xml, _opts) do
    {:ok, element, _tail} = :erlsom.simple_form(xml)
    element
  end
end
