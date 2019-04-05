xml.instruct!
xml.tag! "SOAP-ENV:Envelope", "xmlns:SOAP-ENV" => 'http://schemas.xmlsoap.org/soap/envelope/',
                              "xmlns:ns1" => @ns1,
                              "xmlns:ns2" => @ns2 do
  if !header.nil?
    xml.tag! "SOAP-ENV:Header" do
      xml.tag! "ns2:#{@action_spec[:response_tag]}" do
        wsdl_data xml, header
      end
    end
  end
  xml.tag! "SOAP-ENV:Body" do
    xml.tag! "ns2:#{@action_spec[:response_tag]}" do
      wsdl_data xml, result
    end
  end
end
