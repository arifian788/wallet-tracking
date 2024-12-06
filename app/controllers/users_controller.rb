require("bcrypt")

class UsersController < ApplicationController
    def new
      @user = User.new
    end

    def show
      @user = User.find(session[:user_id])
      @wallets =  Wallet.where(user_id: @user.id)
    end

    def register
      @user = User.new(helpers.user_params)
      if @user.save
        session[:user_name] = @user.name
        Wallet.create(user_id: @user.id, wallet_number: rand(10**9..10**10 - 1), balance: 0)
        session[:wallet_number] = Wallet.last.wallet_number
        redirect_to home_path, status: :created, content_type: "text/html", notice: "Successfully created account"
      else
        puts @user.errors.full_messages
        render :new, status: :unprocessable_entity, content_type: "text/html"
      end
    end

    def home
        if session[:user_id]
          @user_name = session[:user_name]
          @wallet_number = session[:wallet_number]
        else
          redirect_to login_path
        end
    end

    def login
      @user = User.new
    end

    def authenticate
      @user = User.find_by(email: params[:user][:email])

      if @user&.authenticate(params[:user][:password])
        session[:user_id] = @user.id
        session[:user_name] = @user.name
        session[:wallet_number] = Wallet.find_by(user_id: @user.id)&.wallet_number
        redirect_to home_path, notice: "Successfully logged in!"
      else
        @user = User.new
        if @user.errors.empty?
          @user.errors.add(:base, "Invalid email or password")
        end
        render :login, status: :unprocessable_entity
      end
    end

    def logout
      session[:user_id] = nil
      session[:wallet_number] = nil

      redirect_to home_path, notice: "Successfully logged out"
    end
end
