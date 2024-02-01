defmodule XmlToMapTest do
  use ExUnit.Case
  doctest XmlToMap

  test "make a map (naive)" do
    assert XmlToMap.naive_map(sample_xml()) == expectation_naive()
  end

  test "combines sibling nodes with the same name into a list (naive)" do
    assert XmlToMap.naive_map(amazon_xml()) == amazon_expected_naive()
  end

  test "make a map (nested)" do
    assert XmlToMap.nested_map(sample_xml()) == expectation_nested()
  end

  test "combines sibling nodes with the same name into a list (nested)" do
    assert XmlToMap.nested_map(amazon_xml()) == amazon_expected_nested()
  end

  test "empty tag => nil" do
    xml = """
      <xml>
        <id>1</id>
        <name>Value</name>
        <empty></empty>
        <emptyWithAttrs id="123" />
      </xml>
    """

    assert XmlToMap.naive_map(xml) == %{
             "xml" => %{
               "id" => "1",
               "name" => "Value",
               "empty" => nil,
               "emptyWithAttrs" => %{
                 "#content" => nil,
                 "-id" => "123"
               }
             }
           }

    assert XmlToMap.nested_map(xml) == %{
             attributes: [],
             content: [
               %{attributes: [], name: "id", content: "1"},
               %{attributes: [], name: "name", content: "Value"},
               %{attributes: [], name: "empty", content: nil},
               %{attributes: [{"id", "123"}], name: "emptyWithAttrs", content: nil}
             ],
             name: "xml"
           }

    assert XmlToMap.nested_map(xml, purge_empty: true) == %{
             content: [
               %{name: "id", content: "1"},
               %{name: "name", content: "Value"},
               %{name: "empty"},
               %{attributes: [{"id", "123"}], name: "emptyWithAttrs"}
             ],
             name: "xml"
           }
  end

  test "support for custom namespace_match function" do
    assert XmlToMap.naive_map(facebook_xmlns_xml(),
             namespace_match_fn: &set_prefix_namespace_fn/0
           ) == facebook_custom_function_expected()
  end

  test "support for xmlns xml file" do
    assert XmlToMap.naive_map(facebook_xmlns_xml()) == facebook_xmlns_xml_expected()
  end

  def expectation_naive do
    %{
      "orders" => %{
        "order" => [
          %{
            "billing_address" => "My address",
            "id" => "123",
            "items" => %{
              "item" => [
                %{
                  "-currency" => "USD",
                  "#content" => %{
                    "description" => "Hat",
                    "price" => "5.99",
                    "quantity" => "1",
                    "sku" => %{"-lang" => "en", "#content" => "ABC"}
                  }
                },
                %{
                  "-currency" => "USD",
                  "#content" => %{
                    "description" => "Bat",
                    "price" => "9.99",
                    "quantity" => "2",
                    "sku" => "ABC"
                  }
                }
              ]
            }
          },
          %{
            "billing_address" => "Uncle's House",
            "id" => "124",
            "items" => %{
              "item" => %{
                "-currency" => "USD",
                "#content" => %{
                  "description" => "Hat",
                  "price" => "5.99",
                  "quantity" => "2",
                  "sku" => "ABC"
                }
              }
            }
          }
        ]
      }
    }
  end

  def expectation_nested do
    %{
      name: "orders",
      attributes: [],
      content: [
        %{
          name: "order",
          attributes: [],
          content: [
            %{attributes: [], name: "id", content: "123"},
            %{attributes: [], name: "billing_address", content: "My address"},
            %{
              attributes: [],
              name: "items",
              content: [
                %{
                  attributes: [{"currency", "USD"}],
                  name: "item",
                  content: [
                    %{attributes: [{"lang", "en"}], name: "sku", content: "ABC"},
                    %{attributes: [], name: "description", content: "Hat"},
                    %{attributes: [], name: "price", content: "5.99"},
                    %{attributes: [], name: "quantity", content: "1"}
                  ]
                },
                %{
                  attributes: [{"currency", "USD"}],
                  name: "item",
                  content: [
                    %{attributes: [], name: "sku", content: "ABC"},
                    %{attributes: [], name: "description", content: "Bat"},
                    %{attributes: [], name: "price", content: "9.99"},
                    %{attributes: [], name: "quantity", content: "2"}
                  ]
                }
              ]
            }
          ]
        },
        %{
          attributes: [],
          name: "order",
          content: [
            %{attributes: [], name: "id", content: "124"},
            %{attributes: [], name: "billing_address", content: "Uncle's House"},
            %{
              attributes: [],
              name: "items",
              content: %{
                attributes: [{"currency", "USD"}],
                name: "item",
                content: [
                  %{attributes: [], name: "sku", content: "ABC"},
                  %{attributes: [], name: "description", content: "Hat"},
                  %{attributes: [], name: "price", content: "5.99"},
                  %{attributes: [], name: "quantity", content: "2"}
                ]
              }
            }
          ]
        }
      ]
    }
  end

  def sample_xml do
    """
      <orders>
        <order>
          <id>123</id>
          <billing_address>My address</billing_address>
          <items>
            <item currency="USD">
              <sku lang="en">ABC</sku>
              <description>Hat</description>
              <price>5.99</price>
              <quantity>
                1
              </quantity>
            </item>
            <item currency="USD">
              <sku>ABC</sku>
              <description>Bat</description>
              <price>9.99</price>
              <quantity>
                2
              </quantity>
            </item>
          </items>
        </order>
        <order>
          <id>124</id>
          <billing_address>Uncle's House</billing_address>
          <items>
            <item currency="USD">
              <sku>ABC</sku>
              <description>Hat</description>
              <price>5.99</price>
              <quantity>2</quantity>
            </item>
          </items>
        </order>
      </orders>
    """
  end

  def amazon_expected_naive do
    %{
      "GetReportRequestListResponse" => %{
        "GetReportRequestListResult" => %{
          "HasNext" => "true",
          "NextToken" =>
            "bnKUjUwrpfD2jpZedg0wbVuY6vtoszFEs90MCUIyGQ/PkNXwVrATLSf6YzH8PQiWICyhlLgHd4gqVtOYt5i3YX/y5ZICxITwrMWltwHPross7S2LHmNKmcpVErfopfm7ZgI5YM+bbLFRPCnQrq7eGPqiUs2SoKaRPxuuVZAjoAG5Hd34Twm1igafEPREmauvQPEfQK/OReJ9wNJ/XIY3rAvjRfjTJJa5YKoSylcR8gttj983g7esDr0wZ3V0GwaZstMPcqxOnL//uIo+owquzirF36SWlaJ9J5zSS6le1iIsxqkIMXCWKNSOyeZZ1ics+UXSqjS0c15jmJnjJN2V5uMEDoXRsC9PFEVVZ6joTY2uGFVSjAf2NsFIcEAdr4xQz2Y051TPxxk=",
          "ReportRequestInfo" => [
            %{
              "CompletedDate" => "2016-11-18T20:53:14+00:00",
              "EndDate" => "2016-11-18T20:53:00+00:00",
              "GeneratedReportId" => "3412841972017123",
              "ReportProcessingStatus" => "_DONE_",
              "ReportRequestId" => "50920017123",
              "ReportType" => "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_",
              "Scheduled" => "false",
              "StartDate" => "2016-11-18T20:53:00+00:00",
              "StartedProcessingDate" => "2016-11-18T20:53:07+00:00",
              "SubmittedDate" => "2016-11-18T20:53:00+00:00"
            },
            %{
              "CompletedDate" => "2016-11-18T20:51:57+00:00",
              "EndDate" => "2016-11-18T20:51:44+00:00",
              "GeneratedReportId" => "3414908503017123",
              "ReportProcessingStatus" => "_DONE_",
              "ReportRequestId" => "50919017123",
              "ReportType" => "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_",
              "Scheduled" => "false",
              "StartDate" => "2016-11-18T20:51:44+00:00",
              "StartedProcessingDate" => "2016-11-18T20:51:49+00:00",
              "SubmittedDate" => "2016-11-18T20:51:44+00:00"
            },
            %{
              "CompletedDate" => "2016-11-18T14:54:24+00:00",
              "EndDate" => "2016-11-18T14:54:10+00:00",
              "GeneratedReportId" => "3410642176017123",
              "ReportProcessingStatus" => "_DONE_",
              "ReportRequestId" => "50918017123",
              "ReportType" => "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_",
              "Scheduled" => "false",
              "StartDate" => "2016-11-18T14:54:10+00:00",
              "StartedProcessingDate" => "2016-11-18T14:54:17+00:00",
              "SubmittedDate" => "2016-11-18T14:54:10+00:00"
            },
            %{
              "CompletedDate" => "2016-11-18T14:52:37+00:00",
              "EndDate" => "2016-11-18T14:52:26+00:00",
              "GeneratedReportId" => "3417419172017123",
              "ReportProcessingStatus" => "_DONE_",
              "ReportRequestId" => "50917017123",
              "ReportType" => "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_",
              "Scheduled" => "false",
              "StartDate" => "2016-11-18T14:52:26+00:00",
              "StartedProcessingDate" => "2016-11-18T14:52:32+00:00",
              "SubmittedDate" => "2016-11-18T14:52:26+00:00"
            },
            %{
              "CompletedDate" => "2016-11-18T08:54:01+00:00",
              "EndDate" => "2016-11-18T08:53:49+00:00",
              "GeneratedReportId" => "3408643280017123",
              "ReportProcessingStatus" => "_DONE_",
              "ReportRequestId" => "50916017123",
              "ReportType" => "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_",
              "Scheduled" => "false",
              "StartDate" => "2016-11-18T08:53:49+00:00",
              "StartedProcessingDate" => "2016-11-18T08:53:54+00:00",
              "SubmittedDate" => "2016-11-18T08:53:49+00:00"
            },
            %{
              "CompletedDate" => "2016-11-18T08:51:55+00:00",
              "EndDate" => "2016-11-18T08:51:43+00:00",
              "GeneratedReportId" => "3410105984017123",
              "ReportProcessingStatus" => "_DONE_",
              "ReportRequestId" => "50915017123",
              "ReportType" => "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_",
              "Scheduled" => "false",
              "StartDate" => "2016-11-18T08:51:43+00:00",
              "StartedProcessingDate" => "2016-11-18T08:51:49+00:00",
              "SubmittedDate" => "2016-11-18T08:51:43+00:00"
            },
            %{
              "CompletedDate" => "2016-11-18T02:57:46+00:00",
              "EndDate" => "2016-11-18T02:57:34+00:00",
              "GeneratedReportId" => "3408556063017123",
              "ReportProcessingStatus" => "_DONE_",
              "ReportRequestId" => "50914017123",
              "ReportType" => "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_",
              "Scheduled" => "false",
              "StartDate" => "2016-11-18T02:57:34+00:00",
              "StartedProcessingDate" => "2016-11-18T02:57:39+00:00",
              "SubmittedDate" => "2016-11-18T02:57:34+00:00"
            },
            %{
              "CompletedDate" => "2016-11-18T02:56:12+00:00",
              "EndDate" => "2016-11-18T02:55:59+00:00",
              "GeneratedReportId" => "3402759511017123",
              "ReportProcessingStatus" => "_DONE_",
              "ReportRequestId" => "50913017123",
              "ReportType" => "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_",
              "Scheduled" => "false",
              "StartDate" => "2016-11-18T02:55:59+00:00",
              "StartedProcessingDate" => "2016-11-18T02:56:05+00:00",
              "SubmittedDate" => "2016-11-18T02:55:59+00:00"
            },
            %{
              "CompletedDate" => "2016-11-17T20:56:04+00:00",
              "EndDate" => "2016-11-17T20:55:49+00:00",
              "GeneratedReportId" => "3399094295017122",
              "ReportProcessingStatus" => "_DONE_",
              "ReportRequestId" => "50912017122",
              "ReportType" => "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_",
              "Scheduled" => "false",
              "StartDate" => "2016-11-17T20:55:49+00:00",
              "StartedProcessingDate" => "2016-11-17T20:55:54+00:00",
              "SubmittedDate" => "2016-11-17T20:55:49+00:00"
            },
            %{
              "CompletedDate" => "2016-11-17T20:54:45+00:00",
              "EndDate" => "2016-11-17T20:54:33+00:00",
              "GeneratedReportId" => "3405850523017122",
              "ReportProcessingStatus" => "_DONE_",
              "ReportRequestId" => "50911017122",
              "ReportType" => "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_",
              "Scheduled" => "false",
              "StartDate" => "2016-11-17T20:54:33+00:00",
              "StartedProcessingDate" => "2016-11-17T20:54:39+00:00",
              "SubmittedDate" => "2016-11-17T20:54:33+00:00"
            }
          ]
        },
        "ResponseMetadata" => %{"RequestId" => "7509cdb2-0b69-4ca0-89dc-c77f8a747834"}
      }
    }
  end

  def amazon_expected_nested do
    %{
      attributes: [],
      content: [
        %{
          attributes: [],
          name: "GetReportRequestListResult",
          content: [
            %{attributes: [], name: "HasNext", content: "true"},
            %{
              attributes: [],
              name: "ReportRequestInfo",
              content: [
                %{
                  attributes: [],
                  name: "ReportType",
                  content: "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_"
                },
                %{attributes: [], name: "ReportProcessingStatus", content: "_DONE_"},
                %{attributes: [], name: "EndDate", content: "2016-11-18T20:53:00+00:00"},
                %{attributes: [], name: "Scheduled", content: "false"},
                %{attributes: [], name: "ReportRequestId", content: "50920017123"},
                %{
                  attributes: [],
                  name: "StartedProcessingDate",
                  content: "2016-11-18T20:53:07+00:00"
                },
                %{attributes: [], name: "SubmittedDate", content: "2016-11-18T20:53:00+00:00"},
                %{attributes: [], name: "StartDate", content: "2016-11-18T20:53:00+00:00"},
                %{attributes: [], name: "CompletedDate", content: "2016-11-18T20:53:14+00:00"},
                %{attributes: [], name: "GeneratedReportId", content: "3412841972017123"}
              ]
            },
            %{
              attributes: [],
              name: "ReportRequestInfo",
              content: [
                %{
                  attributes: [],
                  name: "ReportType",
                  content: "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_"
                },
                %{attributes: [], name: "ReportProcessingStatus", content: "_DONE_"},
                %{attributes: [], name: "EndDate", content: "2016-11-18T20:51:44+00:00"},
                %{attributes: [], name: "Scheduled", content: "false"},
                %{attributes: [], name: "ReportRequestId", content: "50919017123"},
                %{
                  attributes: [],
                  name: "StartedProcessingDate",
                  content: "2016-11-18T20:51:49+00:00"
                },
                %{attributes: [], name: "SubmittedDate", content: "2016-11-18T20:51:44+00:00"},
                %{attributes: [], name: "StartDate", content: "2016-11-18T20:51:44+00:00"},
                %{attributes: [], name: "CompletedDate", content: "2016-11-18T20:51:57+00:00"},
                %{attributes: [], name: "GeneratedReportId", content: "3414908503017123"}
              ]
            },
            %{
              attributes: [],
              name: "ReportRequestInfo",
              content: [
                %{
                  attributes: [],
                  name: "ReportType",
                  content: "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_"
                },
                %{attributes: [], name: "ReportProcessingStatus", content: "_DONE_"},
                %{attributes: [], name: "EndDate", content: "2016-11-18T14:54:10+00:00"},
                %{attributes: [], name: "Scheduled", content: "false"},
                %{attributes: [], name: "ReportRequestId", content: "50918017123"},
                %{
                  attributes: [],
                  name: "StartedProcessingDate",
                  content: "2016-11-18T14:54:17+00:00"
                },
                %{attributes: [], name: "SubmittedDate", content: "2016-11-18T14:54:10+00:00"},
                %{attributes: [], name: "StartDate", content: "2016-11-18T14:54:10+00:00"},
                %{attributes: [], name: "CompletedDate", content: "2016-11-18T14:54:24+00:00"},
                %{attributes: [], name: "GeneratedReportId", content: "3410642176017123"}
              ]
            },
            %{
              attributes: [],
              name: "ReportRequestInfo",
              content: [
                %{
                  attributes: [],
                  name: "ReportType",
                  content: "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_"
                },
                %{attributes: [], name: "ReportProcessingStatus", content: "_DONE_"},
                %{attributes: [], name: "EndDate", content: "2016-11-18T14:52:26+00:00"},
                %{attributes: [], name: "Scheduled", content: "false"},
                %{attributes: [], name: "ReportRequestId", content: "50917017123"},
                %{
                  attributes: [],
                  name: "StartedProcessingDate",
                  content: "2016-11-18T14:52:32+00:00"
                },
                %{attributes: [], name: "SubmittedDate", content: "2016-11-18T14:52:26+00:00"},
                %{attributes: [], name: "StartDate", content: "2016-11-18T14:52:26+00:00"},
                %{attributes: [], name: "CompletedDate", content: "2016-11-18T14:52:37+00:00"},
                %{attributes: [], name: "GeneratedReportId", content: "3417419172017123"}
              ]
            },
            %{
              attributes: [],
              name: "ReportRequestInfo",
              content: [
                %{
                  attributes: [],
                  name: "ReportType",
                  content: "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_"
                },
                %{attributes: [], name: "ReportProcessingStatus", content: "_DONE_"},
                %{attributes: [], name: "EndDate", content: "2016-11-18T08:53:49+00:00"},
                %{attributes: [], name: "Scheduled", content: "false"},
                %{attributes: [], name: "ReportRequestId", content: "50916017123"},
                %{
                  attributes: [],
                  name: "StartedProcessingDate",
                  content: "2016-11-18T08:53:54+00:00"
                },
                %{attributes: [], name: "SubmittedDate", content: "2016-11-18T08:53:49+00:00"},
                %{attributes: [], name: "StartDate", content: "2016-11-18T08:53:49+00:00"},
                %{attributes: [], name: "CompletedDate", content: "2016-11-18T08:54:01+00:00"},
                %{attributes: [], name: "GeneratedReportId", content: "3408643280017123"}
              ]
            },
            %{
              attributes: [],
              name: "ReportRequestInfo",
              content: [
                %{
                  attributes: [],
                  name: "ReportType",
                  content: "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_"
                },
                %{attributes: [], name: "ReportProcessingStatus", content: "_DONE_"},
                %{attributes: [], name: "EndDate", content: "2016-11-18T08:51:43+00:00"},
                %{attributes: [], name: "Scheduled", content: "false"},
                %{attributes: [], name: "ReportRequestId", content: "50915017123"},
                %{
                  attributes: [],
                  name: "StartedProcessingDate",
                  content: "2016-11-18T08:51:49+00:00"
                },
                %{attributes: [], name: "SubmittedDate", content: "2016-11-18T08:51:43+00:00"},
                %{attributes: [], name: "StartDate", content: "2016-11-18T08:51:43+00:00"},
                %{attributes: [], name: "CompletedDate", content: "2016-11-18T08:51:55+00:00"},
                %{attributes: [], name: "GeneratedReportId", content: "3410105984017123"}
              ]
            },
            %{
              attributes: [],
              name: "ReportRequestInfo",
              content: [
                %{
                  attributes: [],
                  name: "ReportType",
                  content: "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_"
                },
                %{attributes: [], name: "ReportProcessingStatus", content: "_DONE_"},
                %{attributes: [], name: "EndDate", content: "2016-11-18T02:57:34+00:00"},
                %{attributes: [], name: "Scheduled", content: "false"},
                %{attributes: [], name: "ReportRequestId", content: "50914017123"},
                %{
                  attributes: [],
                  name: "StartedProcessingDate",
                  content: "2016-11-18T02:57:39+00:00"
                },
                %{attributes: [], name: "SubmittedDate", content: "2016-11-18T02:57:34+00:00"},
                %{attributes: [], name: "StartDate", content: "2016-11-18T02:57:34+00:00"},
                %{attributes: [], name: "CompletedDate", content: "2016-11-18T02:57:46+00:00"},
                %{attributes: [], name: "GeneratedReportId", content: "3408556063017123"}
              ]
            },
            %{
              attributes: [],
              name: "ReportRequestInfo",
              content: [
                %{
                  attributes: [],
                  name: "ReportType",
                  content: "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_"
                },
                %{attributes: [], name: "ReportProcessingStatus", content: "_DONE_"},
                %{attributes: [], name: "EndDate", content: "2016-11-18T02:55:59+00:00"},
                %{attributes: [], name: "Scheduled", content: "false"},
                %{attributes: [], name: "ReportRequestId", content: "50913017123"},
                %{
                  attributes: [],
                  name: "StartedProcessingDate",
                  content: "2016-11-18T02:56:05+00:00"
                },
                %{attributes: [], name: "SubmittedDate", content: "2016-11-18T02:55:59+00:00"},
                %{attributes: [], name: "StartDate", content: "2016-11-18T02:55:59+00:00"},
                %{attributes: [], name: "CompletedDate", content: "2016-11-18T02:56:12+00:00"},
                %{attributes: [], name: "GeneratedReportId", content: "3402759511017123"}
              ]
            },
            %{
              attributes: [],
              name: "ReportRequestInfo",
              content: [
                %{
                  attributes: [],
                  name: "ReportType",
                  content: "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_"
                },
                %{attributes: [], name: "ReportProcessingStatus", content: "_DONE_"},
                %{attributes: [], name: "EndDate", content: "2016-11-17T20:55:49+00:00"},
                %{attributes: [], name: "Scheduled", content: "false"},
                %{attributes: [], name: "ReportRequestId", content: "50912017122"},
                %{
                  attributes: [],
                  name: "StartedProcessingDate",
                  content: "2016-11-17T20:55:54+00:00"
                },
                %{attributes: [], name: "SubmittedDate", content: "2016-11-17T20:55:49+00:00"},
                %{attributes: [], name: "StartDate", content: "2016-11-17T20:55:49+00:00"},
                %{attributes: [], name: "CompletedDate", content: "2016-11-17T20:56:04+00:00"},
                %{attributes: [], name: "GeneratedReportId", content: "3399094295017122"}
              ]
            },
            %{
              attributes: [],
              name: "ReportRequestInfo",
              content: [
                %{
                  attributes: [],
                  name: "ReportType",
                  content: "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_"
                },
                %{attributes: [], name: "ReportProcessingStatus", content: "_DONE_"},
                %{attributes: [], name: "EndDate", content: "2016-11-17T20:54:33+00:00"},
                %{attributes: [], name: "Scheduled", content: "false"},
                %{attributes: [], name: "ReportRequestId", content: "50911017122"},
                %{
                  attributes: [],
                  name: "StartedProcessingDate",
                  content: "2016-11-17T20:54:39+00:00"
                },
                %{attributes: [], name: "SubmittedDate", content: "2016-11-17T20:54:33+00:00"},
                %{attributes: [], name: "StartDate", content: "2016-11-17T20:54:33+00:00"},
                %{attributes: [], name: "CompletedDate", content: "2016-11-17T20:54:45+00:00"},
                %{attributes: [], name: "GeneratedReportId", content: "3405850523017122"}
              ]
            },
            %{
              attributes: [],
              name: "NextToken",
              content:
                "bnKUjUwrpfD2jpZedg0wbVuY6vtoszFEs90MCUIyGQ/PkNXwVrATLSf6YzH8PQiWICyhlLgHd4gqVtOYt5i3YX/y5ZICxITwrMWltwHPross7S2LHmNKmcpVErfopfm7ZgI5YM+bbLFRPCnQrq7eGPqiUs2SoKaRPxuuVZAjoAG5Hd34Twm1igafEPREmauvQPEfQK/OReJ9wNJ/XIY3rAvjRfjTJJa5YKoSylcR8gttj983g7esDr0wZ3V0GwaZstMPcqxOnL//uIo+owquzirF36SWlaJ9J5zSS6le1iIsxqkIMXCWKNSOyeZZ1ics+UXSqjS0c15jmJnjJN2V5uMEDoXRsC9PFEVVZ6joTY2uGFVSjAf2NsFIcEAdr4xQz2Y051TPxxk="
            }
          ]
        },
        %{
          attributes: [],
          name: "ResponseMetadata",
          content: %{
            attributes: [],
            name: "RequestId",
            content: "7509cdb2-0b69-4ca0-89dc-c77f8a747834"
          }
        }
      ],
      name: "GetReportRequestListResponse"
    }
  end

  def set_prefix_namespace_fn do
    fn name, namespace, prefix ->
      cond do
        namespace != [] && prefix != [] -> "#{prefix}_namespace:#{name}"
        true -> name
      end
    end
  end

  def facebook_custom_function_expected do
    %{
      "rss" => %{
        "#content" => %{
          "channel" => %{
            "title" => "Test Store",
            "link" => "http://www.example.com",
            "description" => "An example item from the feed",
            "item" => %{
              "g_namespace:id" => "DB_1",
              "g_namespace:title" => "Dog Bowl In Blue",
              "g_namespace:description" => "Solid plastic Dog Bowl in marine blue color",
              "g_namespace:link" => "http://www.example.com/bowls/db-1.html",
              "g_namespace:image_link" => "http://images.example.com/DB_1.png",
              "g_namespace:brand" => "Example",
              "g_namespace:condition" => "new",
              "g_namespace:availability" => "in stock",
              "g_namespace:price" => "9.99 GBP",
              "g_namespace:shipping" => %{
                "g_namespace:country" => "UK",
                "g_namespace:service" => "Standard",
                "g_namespace:price" => "4.95 GBP"
              },
              "g_namespace:google_product_category" => "Animals > Pet Supplies",
              "g_namespace:custom_label_0" => "Made in Waterford, IE"
            }
          }
        },
        "-version" => "2.0"
      }
    }
  end

  def facebook_xmlns_xml_expected do
    %{
      "rss" => %{
        "#content" => %{
          "channel" => %{
            "title" => "Test Store",
            "link" => "http://www.example.com",
            "description" => "An example item from the feed",
            "item" => %{
              "g:id" => "DB_1",
              "g:title" => "Dog Bowl In Blue",
              "g:description" => "Solid plastic Dog Bowl in marine blue color",
              "g:link" => "http://www.example.com/bowls/db-1.html",
              "g:image_link" => "http://images.example.com/DB_1.png",
              "g:brand" => "Example",
              "g:condition" => "new",
              "g:availability" => "in stock",
              "g:price" => "9.99 GBP",
              "g:shipping" => %{
                "g:country" => "UK",
                "g:service" => "Standard",
                "g:price" => "4.95 GBP"
              },
              "g:google_product_category" => "Animals > Pet Supplies",
              "g:custom_label_0" => "Made in Waterford, IE"
            }
          }
        },
        "-version" => "2.0"
      }
    }
  end

  def facebook_xmlns_xml do
    """
    <?xml version="1.0"?>
    <rss xmlns:g="http://base.google.com/ns/1.0" version="2.0">
      <channel>
        <title>Test Store</title>
        <link>http://www.example.com</link>
        <description>An example item from the feed</description>
        <item>
          <g:id>DB_1</g:id>
          <g:title>Dog Bowl In Blue</g:title>
          <g:description>Solid plastic Dog Bowl in marine blue color</g:description>
          <g:link>http://www.example.com/bowls/db-1.html</g:link>
          <g:image_link>http://images.example.com/DB_1.png</g:image_link>
          <g:brand>Example</g:brand>
          <g:condition>new</g:condition>
          <g:availability>in stock</g:availability>
          <g:price>9.99 GBP</g:price>
          <g:shipping>
          <g:country>UK</g:country>
          <g:service>Standard</g:service>
          <g:price>4.95 GBP</g:price>
          </g:shipping>
          <g:google_product_category>Animals > Pet Supplies</g:google_product_category>
          <g:custom_label_0>Made in Waterford, IE</g:custom_label_0>
        </item>
      </channel>
    </rss>
    """
  end

  def amazon_xml do
    """
    <?xml version="1.0"?>
    <GetReportRequestListResponse xmlns="http://mws.amazonaws.com/doc/2009-01-01/">
      <GetReportRequestListResult>
        <HasNext>true</HasNext>
        <ReportRequestInfo>
          <ReportType>_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_</ReportType>
          <ReportProcessingStatus>_DONE_</ReportProcessingStatus>
          <EndDate>2016-11-18T20:53:00+00:00</EndDate>
          <Scheduled>false</Scheduled>
          <ReportRequestId>50920017123</ReportRequestId>
          <StartedProcessingDate>2016-11-18T20:53:07+00:00</StartedProcessingDate>
          <SubmittedDate>2016-11-18T20:53:00+00:00</SubmittedDate>
          <StartDate>2016-11-18T20:53:00+00:00</StartDate>
          <CompletedDate>2016-11-18T20:53:14+00:00</CompletedDate>
          <GeneratedReportId>3412841972017123</GeneratedReportId>
        </ReportRequestInfo>
        <ReportRequestInfo>
          <ReportType>_GET_AFN_INVENTORY_DATA_BY_COUNTRY_</ReportType>
          <ReportProcessingStatus>_DONE_</ReportProcessingStatus>
          <EndDate>2016-11-18T20:51:44+00:00</EndDate>
          <Scheduled>false</Scheduled>
          <ReportRequestId>50919017123</ReportRequestId>
          <StartedProcessingDate>2016-11-18T20:51:49+00:00</StartedProcessingDate>
          <SubmittedDate>2016-11-18T20:51:44+00:00</SubmittedDate>
          <StartDate>2016-11-18T20:51:44+00:00</StartDate>
          <CompletedDate>2016-11-18T20:51:57+00:00</CompletedDate>
          <GeneratedReportId>3414908503017123</GeneratedReportId>
        </ReportRequestInfo>
        <ReportRequestInfo>
          <ReportType>_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_</ReportType>
          <ReportProcessingStatus>_DONE_</ReportProcessingStatus>
          <EndDate>2016-11-18T14:54:10+00:00</EndDate>
          <Scheduled>false</Scheduled>
          <ReportRequestId>50918017123</ReportRequestId>
          <StartedProcessingDate>2016-11-18T14:54:17+00:00</StartedProcessingDate>
          <SubmittedDate>2016-11-18T14:54:10+00:00</SubmittedDate>
          <StartDate>2016-11-18T14:54:10+00:00</StartDate>
          <CompletedDate>2016-11-18T14:54:24+00:00</CompletedDate>
          <GeneratedReportId>3410642176017123</GeneratedReportId>
        </ReportRequestInfo>
        <ReportRequestInfo>
          <ReportType>_GET_AFN_INVENTORY_DATA_BY_COUNTRY_</ReportType>
          <ReportProcessingStatus>_DONE_</ReportProcessingStatus>
          <EndDate>2016-11-18T14:52:26+00:00</EndDate>
          <Scheduled>false</Scheduled>
          <ReportRequestId>50917017123</ReportRequestId>
          <StartedProcessingDate>2016-11-18T14:52:32+00:00</StartedProcessingDate>
          <SubmittedDate>2016-11-18T14:52:26+00:00</SubmittedDate>
          <StartDate>2016-11-18T14:52:26+00:00</StartDate>
          <CompletedDate>2016-11-18T14:52:37+00:00</CompletedDate>
          <GeneratedReportId>3417419172017123</GeneratedReportId>
        </ReportRequestInfo>
        <ReportRequestInfo>
          <ReportType>_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_</ReportType>
          <ReportProcessingStatus>_DONE_</ReportProcessingStatus>
          <EndDate>2016-11-18T08:53:49+00:00</EndDate>
          <Scheduled>false</Scheduled>
          <ReportRequestId>50916017123</ReportRequestId>
          <StartedProcessingDate>2016-11-18T08:53:54+00:00</StartedProcessingDate>
          <SubmittedDate>2016-11-18T08:53:49+00:00</SubmittedDate>
          <StartDate>2016-11-18T08:53:49+00:00</StartDate>
          <CompletedDate>2016-11-18T08:54:01+00:00</CompletedDate>
          <GeneratedReportId>3408643280017123</GeneratedReportId>
        </ReportRequestInfo>
        <ReportRequestInfo>
          <ReportType>_GET_AFN_INVENTORY_DATA_BY_COUNTRY_</ReportType>
          <ReportProcessingStatus>_DONE_</ReportProcessingStatus>
          <EndDate>2016-11-18T08:51:43+00:00</EndDate>
          <Scheduled>false</Scheduled>
          <ReportRequestId>50915017123</ReportRequestId>
          <StartedProcessingDate>2016-11-18T08:51:49+00:00</StartedProcessingDate>
          <SubmittedDate>2016-11-18T08:51:43+00:00</SubmittedDate>
          <StartDate>2016-11-18T08:51:43+00:00</StartDate>
          <CompletedDate>2016-11-18T08:51:55+00:00</CompletedDate>
          <GeneratedReportId>3410105984017123</GeneratedReportId>
        </ReportRequestInfo>
        <ReportRequestInfo>
          <ReportType>_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_</ReportType>
          <ReportProcessingStatus>_DONE_</ReportProcessingStatus>
          <EndDate>2016-11-18T02:57:34+00:00</EndDate>
          <Scheduled>false</Scheduled>
          <ReportRequestId>50914017123</ReportRequestId>
          <StartedProcessingDate>2016-11-18T02:57:39+00:00</StartedProcessingDate>
          <SubmittedDate>2016-11-18T02:57:34+00:00</SubmittedDate>
          <StartDate>2016-11-18T02:57:34+00:00</StartDate>
          <CompletedDate>2016-11-18T02:57:46+00:00</CompletedDate>
          <GeneratedReportId>3408556063017123</GeneratedReportId>
        </ReportRequestInfo>
        <ReportRequestInfo>
          <ReportType>_GET_AFN_INVENTORY_DATA_BY_COUNTRY_</ReportType>
          <ReportProcessingStatus>_DONE_</ReportProcessingStatus>
          <EndDate>2016-11-18T02:55:59+00:00</EndDate>
          <Scheduled>false</Scheduled>
          <ReportRequestId>50913017123</ReportRequestId>
          <StartedProcessingDate>2016-11-18T02:56:05+00:00</StartedProcessingDate>
          <SubmittedDate>2016-11-18T02:55:59+00:00</SubmittedDate>
          <StartDate>2016-11-18T02:55:59+00:00</StartDate>
          <CompletedDate>2016-11-18T02:56:12+00:00</CompletedDate>
          <GeneratedReportId>3402759511017123</GeneratedReportId>
        </ReportRequestInfo>
        <ReportRequestInfo>
          <ReportType>_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_</ReportType>
          <ReportProcessingStatus>_DONE_</ReportProcessingStatus>
          <EndDate>2016-11-17T20:55:49+00:00</EndDate>
          <Scheduled>false</Scheduled>
          <ReportRequestId>50912017122</ReportRequestId>
          <StartedProcessingDate>2016-11-17T20:55:54+00:00</StartedProcessingDate>
          <SubmittedDate>2016-11-17T20:55:49+00:00</SubmittedDate>
          <StartDate>2016-11-17T20:55:49+00:00</StartDate>
          <CompletedDate>2016-11-17T20:56:04+00:00</CompletedDate>
          <GeneratedReportId>3399094295017122</GeneratedReportId>
        </ReportRequestInfo>
        <ReportRequestInfo>
          <ReportType>_GET_AFN_INVENTORY_DATA_BY_COUNTRY_</ReportType>
          <ReportProcessingStatus>_DONE_</ReportProcessingStatus>
          <EndDate>2016-11-17T20:54:33+00:00</EndDate>
          <Scheduled>false</Scheduled>
          <ReportRequestId>50911017122</ReportRequestId>
          <StartedProcessingDate>2016-11-17T20:54:39+00:00</StartedProcessingDate>
          <SubmittedDate>2016-11-17T20:54:33+00:00</SubmittedDate>
          <StartDate>2016-11-17T20:54:33+00:00</StartDate>
          <CompletedDate>2016-11-17T20:54:45+00:00</CompletedDate>
          <GeneratedReportId>3405850523017122</GeneratedReportId>
        </ReportRequestInfo>
        <NextToken>bnKUjUwrpfD2jpZedg0wbVuY6vtoszFEs90MCUIyGQ/PkNXwVrATLSf6YzH8PQiWICyhlLgHd4gqVtOYt5i3YX/y5ZICxITwrMWltwHPross7S2LHmNKmcpVErfopfm7ZgI5YM+bbLFRPCnQrq7eGPqiUs2SoKaRPxuuVZAjoAG5Hd34Twm1igafEPREmauvQPEfQK/OReJ9wNJ/XIY3rAvjRfjTJJa5YKoSylcR8gttj983g7esDr0wZ3V0GwaZstMPcqxOnL//uIo+owquzirF36SWlaJ9J5zSS6le1iIsxqkIMXCWKNSOyeZZ1ics+UXSqjS0c15jmJnjJN2V5uMEDoXRsC9PFEVVZ6joTY2uGFVSjAf2NsFIcEAdr4xQz2Y051TPxxk=</NextToken>
      </GetReportRequestListResult>
      <ResponseMetadata>
        <RequestId>7509cdb2-0b69-4ca0-89dc-c77f8a747834</RequestId>
      </ResponseMetadata>
    </GetReportRequestListResponse>
    """
  end
end
