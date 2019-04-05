xml.instruct!
xml.tag! "SOAP-ENV:Envelope", "xmlns:SOAP-ENV" => 'http://schemas.xmlsoap.org/soap/envelope/' do
  xml.tag! "SOAP-ENV:Body" do
    xml.tag! "SOAP-ENV:Fault" do
      xml.faultcode error_code
      xml.faultstring error_message
    end
  end
end
