module QRCode
  class Connection
    BASE_URL = "http://api.qrserver.com/v1/"

    def fetch_result(url)
      connection = Excon.new(url)
      response = connection.get
      return nil if response.status != 200
      response.body
    end

    def self.generate_code(data)
      url = BASE_URL + '/create-qr-code/?data=' + URI.encode(name)
      fetch_result(url)
    end


  end
end
