defmodule XmlToMapTest do
  use ExUnit.Case
  doctest XmlToMap

  test "make a map" do
    assert XmlToMap.naive_map(sample_xml) == expectation
  end

  def expectation do
    %{"Orders" => %{"foo" => "bar",
    "order" => [%{"billing_address" => "My address", "id" => "123",
       "items" => %{"item" => %{"description" => "Hat", "itemfoo" => "itembar",
           "price" => "5.99", "quantity" => "1", "sku" => "ABC"},
         "itemsfoo" => "itemsbar"}},
     %{"billing_address" => "Uncle's House", "id" => "124",
       "items" => %{"item" => %{"description" => "Hat", "price" => "5.99",
           "quantity" => "2", "sku" => "ABC"}}}]}}
  end


  def sample_xml do
  """
    <Orders foo="bar">
      <order>
        <id>123</id>
        <billing_address>My address</billing_address>
        <items itemsfoo="itemsbar">
          <item itemfoo="itembar">
            <sku skufoo="skubar">ABC</sku>
            <description>Hat</description>
            <price>5.99</price>
            <quantity>
              1
            </quantity>
          </item>
        </items>
      </order>
      <order>
        <id>124</id>
        <billing_address>Uncle's House</billing_address>
        <items>
          <item>
            <sku>ABC</sku>
            <description>Hat</description>
            <price>5.99</price>
            <quantity>2</quantity>
          </item>
        </items>
      </order>
    </Orders>
  """
  end
end
