class ApplicationController < Sinatra::Base

  configure do
    set :root,  File.dirname(__FILE__).sub('controllers', '')
    set :views, Proc.new { File.join(root, 'views') }
  end

  @api = {}
  
  before do
    if request.env["PATH_INFO"] == '/'
      content_type 'text/html'
    else      
      content_type 'application/json'
    end
  end

  set(:authorization) do |*roles|
    condition do
      begin
        authorization_header = request.env['HTTP_AUTHORIZATION']
        unless authorization_header.include? 'Bearer'
          raise "Unauthorized"
        end
        
        token = authorization_header.sub "Bearer ", ""
        userInfo = JSON.parse Base64.strict_decode64 token

        @user = User.find(userInfo["id"])
        unless @user
          raise "Unauthorized"
        end

        if !roles.empty? && (!@user.staff || !roles.include?(@user.staff.role))
          halt 403, {error: "Forbidden"}.to_json 
        end

        # pp userInfo
      rescue => exception
        halt 401, {error: "Unauthorized"}.to_json
      end

    end
  end
  
  # API Documentation
  get "/", :provides => ['html', :views] do
    # pp request.env
    erb :index, :locals => {
      :api => {
        user: [
          {
            path:'/user',
            method: 'GET', 
            description:'Get user information' 
          },
          
          {
            path:'/user/signup',
            method: 'POST', 
            description:'For registering users'
          },
          
          {
            path:'/user/signin',
            method: 'POST', 
            description:'For signing in a user'
          }
        ]
      }
    }
  end

  # user routes
  get "/user", :authorization => [] do
    @user.to_json( only: [:name, :email, :phone] )
  end

  post "/user/signup" do

    if User.find_by(email: params[:email])
      halt 400, "Email address already exists"
    end

    if User.find_by(phone: params[:phone])
      halt 400, "Email address already exists"
    end

    user = User.create(
      name: params[:name], 
      email: params[:email], 
      phone: params[:phone], 
      password: params[:password]
    )

    member = Member.create(member_id: "MEM-#{Time.now.to_i}", user_id:user.id)
    Account.create({member_id: member.id, total_savings:0})
    
    {message: "User created successfully"}.to_json

  end

  post "/user/signin" do
    
    user = User.find_by(email: params[:email], password: params[:password])

    pp user
    
    if !user
      halt 401, "Wrong Email or Password"
    end

    token = user.to_json(only: [:name, :email, :id])
    encrypted_token = Base64.strict_encode64(token)

    {token: encrypted_token, exptime:Time.now.to_i}.to_json

  end

  #Users Routes
  get "/users", :authorization=>[:admin] do
    User.all.to_json
  end

  get "/users/:id", :authorization=>[:admin] do
    User.find(params[:id]).to_json(only:[:name, :email, :phone, :avatar], include: { member: {}, accounts:{}})
  end

  post "/users", :authorization=>[:admin] do
    if User.find_by(email: params[:email])
      halt 400, "Email address already exists"
    end

    if User.find_by(phone: params[:phone])
      halt 400, "Email address already exists"
    end

    user = User.create(
      name: params[:name], 
      email: params[:email], 
      phone: params[:phone], 
      password: params[:password]
    )

    member = Member.create(member_id: "MEM-#{Time.now.to_i}", user_id:user.id)
    Account.create({member_id: member.id, total_savings:0})

    user.to_json(only:[:name, :email, :phone, :avatar], include: {member:{}, account:{}} )

  end

  patch "/users", :authorization=>[:admin] do
    if User.find_by(email: params[:email]).where.not(id: params[:id])
      halt 400, "Email address already exists"
    end

    if User.find_by(phone: params[:phone]).where.not(id: params[:id])
      halt 400, "Email address already exists"
    end

    user = User.find(params[:id])

    user.save(
      name: params[:name], 
      email: params[:email], 
      phone: params[:phone], 
      password: params[:password]
    )

    user.to_json(only:[:name, :email, :phone, :avatar], include: {member:{}, account:{}} )
  end

  # Accounts Routes
  get "/account", :authorization => [] do
    @user.member.accounts.to_json( include: :transactions )
  end

  # Transactions routes
  get "/transactions", :authorization => []  do

  end
  
  post "/deposit", :authorization=>[] do

    # Create a trasaxtion first
    transaction = Transaction.create({
      amount: params[:amount],
      txn_type: "D",
      trx_ref: "DEPOSIT-#{Time.now.to_i}",
      txn_response: {phone: params[:phone]}.to_json.to_s,
      narative: "Deposit of KES #{params[:amount]}",
      account_id: @user.accounts[0].id,
      txn_status: "Pending"
    })

    mpesa_client = MpesaClient.new
    stkResponse = mpesa_client.requst_payment(transaction.amount, params[:phone])
    transaction.txn_response = stkResponse.to_json.to_s
    transaction.save
    @user.accounts[0].total_savings += params[:amount].to_i;
    @user.accounts[0].save
    
    transaction.to_json

  end

end
