xml.instruct!
xml.tag! "soap:Envelope", "xmlns:soap" => 'http://www.w3.org/2003/05/soap-envelope',
                          "xmlns:xsd" => 'http://www.w3.org/2001/XMLSchema',
                          "xmlns:ns1" => @ns1,
                          "xmlns:ns2" => @ns2 do
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
