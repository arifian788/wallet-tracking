require("bcrypt")

class UsersController < ApplicationController
    def new
      @user = User.new
    end

    def register
      @user = User.new(helpers.user_params)
      if @user.save
        session[:user_name] = @user.name
        Wallet.create(user_id: @user.id, wallet_number: rand(1_000_000_000), balance: 0)
        session[:wallet_number] = Wallet.last.wallet_number
        redirect_to home_path, notice: "Successfully created account"
      else
        render :new
      end
    end

    def home
        @user_name = session[:user_name]
        @wallet_number = session[:wallet_number]
    end

    def login
      @user = User.new
    end

    def authenticate
        @user = User.find_by(email: params[:email])

        if @user&.authenticate(params[:password])
          session[:user_id] = @user.id
          session[:user_name] = @user.name
          session[:wallet_number] = Wallet.find_by(user_id: @user.id).wallet_number
          redirect_to home_path, notice: "Successfully logged in!"
        else
          flash[:alert] = "Invalid email or password."
          render :login
        end
    end

    def logout
      session[:user_id] = nil
      session[:wallet_number] = nil

      redirect_to register_path, notice: "Successfully logged out"
    end
end
