xml.instruct!
xml.tag! "soap:Envelope", "xmlns:soap" => 'http://schemas.xmlsoap.org/soap/envelope/',
                          "xmlns:xsd" => 'http://www.w3.org/2001/XMLSchema',
                          "xmlns:xsi" => 'http://www.w3.org/2001/XMLSchema-instance',
                          "xmlns:ns1" => "http://schemas.datacontract.org/2004/07/",
                          "xmlns:ns2" => @namespace do
  if !header.nil?
    xml.tag! "soap:Header" do
      xml.tag! "ns2:#{@action_spec[:response_tag]}" do
        wsdl_data xml, header
      end
    end
  end
  xml.tag! "soap:Body" do
    xml.tag! "ns2:#{@action_spec[:response_tag]}" do
      wsdl_data xml, result
    end
  end
end
