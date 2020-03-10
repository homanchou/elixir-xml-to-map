defmodule XmlToMapTest do
  use ExUnit.Case
  doctest XmlToMap

  test "make a map" do
    assert XmlToMap.naive_map(sample_xml()) == expectation()
  end

  test "combines sibling nodes with the same name into a list" do
    assert XmlToMap.naive_map(amazon_xml()) == amazon_expected()
  end

  def expectation do
    %{"Orders" =>
      %{"foo" => "bar",
        "order" => [%{"billing_address" => "My address", "id" => "123",
                      "items" => %{"item" => [%{"description" => "Hat",
                                               "item@itemfoo" => "itembar",
                                               "itemfoo" => "itembar",
                                               "price" => "5.99",
                                               "quantity" => "1",
                                               "sku" => "ABC",
                                               "sku@skufoo" => "skubar"},
                                              %{"description" => "Bat",
                                                "item@itemfoo" => "itembaz",
                                                "itemfoo" => "itembaz",
                                                "price" => "9.99",
                                                "quantity" => "2",
                                                "sku" => "ABC"}],
                                   "itemsfoo" => "itemsbar",
                                   "items@itemsfoo" => "itemsbar"}},
                    %{"billing_address" => "Uncle's House", "id" => "124",
                      "items" => %{"item" => %{"description" => "Hat",
                                               "price" => "5.99",
                                               "quantity" => "2",
                                               "sku" => "ABC"}}
                    }],
        "Orders@foo" => "bar"}}
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
          <item itemfoo="itembaz">
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

  def amazon_expected do
    %{"GetReportRequestListResponse" => %{"GetReportRequestListResult" => %{"HasNext" => "true",
      "NextToken" => "bnKUjUwrpfD2jpZedg0wbVuY6vtoszFEs90MCUIyGQ/PkNXwVrATLSf6YzH8PQiWICyhlLgHd4gqVtOYt5i3YX/y5ZICxITwrMWltwHPross7S2LHmNKmcpVErfopfm7ZgI5YM+bbLFRPCnQrq7eGPqiUs2SoKaRPxuuVZAjoAG5Hd34Twm1igafEPREmauvQPEfQK/OReJ9wNJ/XIY3rAvjRfjTJJa5YKoSylcR8gttj983g7esDr0wZ3V0GwaZstMPcqxOnL//uIo+owquzirF36SWlaJ9J5zSS6le1iIsxqkIMXCWKNSOyeZZ1ics+UXSqjS0c15jmJnjJN2V5uMEDoXRsC9PFEVVZ6joTY2uGFVSjAf2NsFIcEAdr4xQz2Y051TPxxk=",
      "ReportRequestInfo" => [%{"CompletedDate" => "2016-11-18T20:53:14+00:00",
         "EndDate" => "2016-11-18T20:53:00+00:00",
         "GeneratedReportId" => "3412841972017123",
         "ReportProcessingStatus" => "_DONE_",
         "ReportRequestId" => "50920017123",
         "ReportType" => "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_",
         "Scheduled" => "false", "StartDate" => "2016-11-18T20:53:00+00:00",
         "StartedProcessingDate" => "2016-11-18T20:53:07+00:00",
         "SubmittedDate" => "2016-11-18T20:53:00+00:00"},
       %{"CompletedDate" => "2016-11-18T20:51:57+00:00",
         "EndDate" => "2016-11-18T20:51:44+00:00",
         "GeneratedReportId" => "3414908503017123",
         "ReportProcessingStatus" => "_DONE_",
         "ReportRequestId" => "50919017123",
         "ReportType" => "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_",
         "Scheduled" => "false", "StartDate" => "2016-11-18T20:51:44+00:00",
         "StartedProcessingDate" => "2016-11-18T20:51:49+00:00",
         "SubmittedDate" => "2016-11-18T20:51:44+00:00"},
       %{"CompletedDate" => "2016-11-18T14:54:24+00:00",
         "EndDate" => "2016-11-18T14:54:10+00:00",
         "GeneratedReportId" => "3410642176017123",
         "ReportProcessingStatus" => "_DONE_",
         "ReportRequestId" => "50918017123",
         "ReportType" => "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_",
         "Scheduled" => "false", "StartDate" => "2016-11-18T14:54:10+00:00",
         "StartedProcessingDate" => "2016-11-18T14:54:17+00:00",
         "SubmittedDate" => "2016-11-18T14:54:10+00:00"},
       %{"CompletedDate" => "2016-11-18T14:52:37+00:00",
         "EndDate" => "2016-11-18T14:52:26+00:00",
         "GeneratedReportId" => "3417419172017123",
         "ReportProcessingStatus" => "_DONE_",
         "ReportRequestId" => "50917017123",
         "ReportType" => "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_",
         "Scheduled" => "false", "StartDate" => "2016-11-18T14:52:26+00:00",
         "StartedProcessingDate" => "2016-11-18T14:52:32+00:00",
         "SubmittedDate" => "2016-11-18T14:52:26+00:00"},
       %{"CompletedDate" => "2016-11-18T08:54:01+00:00",
         "EndDate" => "2016-11-18T08:53:49+00:00",
         "GeneratedReportId" => "3408643280017123",
         "ReportProcessingStatus" => "_DONE_",
         "ReportRequestId" => "50916017123",
         "ReportType" => "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_",
         "Scheduled" => "false", "StartDate" => "2016-11-18T08:53:49+00:00",
         "StartedProcessingDate" => "2016-11-18T08:53:54+00:00",
         "SubmittedDate" => "2016-11-18T08:53:49+00:00"},
       %{"CompletedDate" => "2016-11-18T08:51:55+00:00",
         "EndDate" => "2016-11-18T08:51:43+00:00",
         "GeneratedReportId" => "3410105984017123",
         "ReportProcessingStatus" => "_DONE_",
         "ReportRequestId" => "50915017123",
         "ReportType" => "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_",
         "Scheduled" => "false", "StartDate" => "2016-11-18T08:51:43+00:00",
         "StartedProcessingDate" => "2016-11-18T08:51:49+00:00",
         "SubmittedDate" => "2016-11-18T08:51:43+00:00"},
       %{"CompletedDate" => "2016-11-18T02:57:46+00:00",
         "EndDate" => "2016-11-18T02:57:34+00:00",
         "GeneratedReportId" => "3408556063017123",
         "ReportProcessingStatus" => "_DONE_",
         "ReportRequestId" => "50914017123",
         "ReportType" => "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_",
         "Scheduled" => "false", "StartDate" => "2016-11-18T02:57:34+00:00",
         "StartedProcessingDate" => "2016-11-18T02:57:39+00:00",
         "SubmittedDate" => "2016-11-18T02:57:34+00:00"},
       %{"CompletedDate" => "2016-11-18T02:56:12+00:00",
         "EndDate" => "2016-11-18T02:55:59+00:00",
         "GeneratedReportId" => "3402759511017123",
         "ReportProcessingStatus" => "_DONE_",
         "ReportRequestId" => "50913017123",
         "ReportType" => "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_",
         "Scheduled" => "false", "StartDate" => "2016-11-18T02:55:59+00:00",
         "StartedProcessingDate" => "2016-11-18T02:56:05+00:00",
         "SubmittedDate" => "2016-11-18T02:55:59+00:00"},
       %{"CompletedDate" => "2016-11-17T20:56:04+00:00",
         "EndDate" => "2016-11-17T20:55:49+00:00",
         "GeneratedReportId" => "3399094295017122",
         "ReportProcessingStatus" => "_DONE_",
         "ReportRequestId" => "50912017122",
         "ReportType" => "_GET_FBA_MYI_UNSUPPRESSED_INVENTORY_DATA_",
         "Scheduled" => "false", "StartDate" => "2016-11-17T20:55:49+00:00",
         "StartedProcessingDate" => "2016-11-17T20:55:54+00:00",
         "SubmittedDate" => "2016-11-17T20:55:49+00:00"},
       %{"CompletedDate" => "2016-11-17T20:54:45+00:00",
         "EndDate" => "2016-11-17T20:54:33+00:00",
         "GeneratedReportId" => "3405850523017122",
         "ReportProcessingStatus" => "_DONE_",
         "ReportRequestId" => "50911017122",
         "ReportType" => "_GET_AFN_INVENTORY_DATA_BY_COUNTRY_",
         "Scheduled" => "false", "StartDate" => "2016-11-17T20:54:33+00:00",
         "StartedProcessingDate" => "2016-11-17T20:54:39+00:00",
         "SubmittedDate" => "2016-11-17T20:54:33+00:00"}]},
    "ResponseMetadata" => %{"RequestId" => "7509cdb2-0b69-4ca0-89dc-c77f8a747834"}}}
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
