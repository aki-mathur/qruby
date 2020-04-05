class QrcodeController < ApplicationController

  def index
  end

  def generate_code
    unless params[:codeText].present?
      flash[:alert] = 'Name not found'
      return render action: :index
    end

    data = Base64.strict_encode64(get_code(params[:codeText]))
    render json: {data: data}, status: 200

  end

  def scan_code
    data = scan_qrcode(params[:file])
    unless data[0]["symbol"][0]["data"].present?
      render json: {errors: data[0]["symbol"][0]["error"]}, status: 422
    else
      render json: {result: data[0]["symbol"][0]["data"]}, status: 200
    end
  end

  private
  def request_api(url)
    connection = Faraday.new(url)
    response = connection.get
    return nil if response.status != 200
    response.body
  end

  def get_code(name)
    request_api(
      "http://api.qrserver.com/v1/create-qr-code/?data=#{name}"
    )
  end

  def scan_qrcode(data)
    conn = Faraday.new('http://api.qrserver.com/v1/read-qr-code/') do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end

    file = Faraday::UploadIO.new(
      data.tempfile.path,
      data.content_type,
      data.original_filename
    )
    payload = { file: file }
    response = conn.post do |req|
      req.body = payload
    end
    return nil if response.status != 200
    JSON.parse(response.body)
  end


end
