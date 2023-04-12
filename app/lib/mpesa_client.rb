class MpesaClient
    include HTTParty

    @@consumer_key="pRYr6zjq0i8L1zzwQDMLpZB3yPCkhMsc"
    @@consumer_secret="Rf22BfZog0qQGlV9"

    base_uri 'https://sandbox.safaricom.co.ke'
  
    def initialize()
    #   @options = { query: { site: service } }
    end

    def requst_payment(amount, mpesa_phone_number)
        puts amount
        puts mpesa_phone_number
        authorization = self.authorization
        pp authorization

        passkey = "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919"
        shortcode = "174379"
        timestamp = Time.now.strftime '%Y%m%d%H%M%S'
        password = Base64.strict_encode64("#{shortcode}#{passkey}#{timestamp}")

        query = {
            "BusinessShortCode": shortcode,    
            "Password": password,    
            "Timestamp": timestamp,    
            "TransactionType": "CustomerPayBillOnline",    
            "Amount": amount,    
            "PartyA": mpesa_phone_number,    
            "PartyB": shortcode,    
            "PhoneNumber": mpesa_phone_number,    
            "CallBackURL": "https://njmwas.web.app/payment",    
            "AccountReference": "Test",    
            "TransactionDesc": "Test"
        }

        self.class.post(
            '/mpesa/stkpush/v1/processrequest', {
                :query => query,
                :headers => {
                    :Authorization => "Bearer #{authorization["access_token"]}",
                    :ContentType => "application/json"
                }
            }
        )
    end

    private
    def authorization
        b64authorization = Base64.strict_encode64("#{@@consumer_key}:#{@@consumer_secret}")
        pp b64authorization
        
        self.class.get(
            '/oauth/v1/generate?grant_type=client_credentials', {
                :query => {:grant_type => "client_credentials"},
                :headers => {:Authorization=> "Basic #{b64authorization}"}
            }
        )
    end

  end