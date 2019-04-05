xml.instruct!
xml.tag! "SOAP-ENV:Envelope", "SOAP-ENV:soap" => 'http://schemas.xmlsoap.org/soap/envelope/',
                          "xmlns:xsi" => 'http://www.w3.org/2001/XMLSchema-instance' do
  xml.tag! "SOAP-ENV:Body" do
    xml.tag! "SOAP-ENV:Fault", :encodingStyle => 'http://schemas.xmlsoap.org/soap/encoding/' do
      xml.faultcode error_code, 'xsi:type' => 'xsd:QName'
      xml.faultstring error_message, 'xsi:type' => 'xsd:string'
    end
  end
end
