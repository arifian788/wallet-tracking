require("bcrypt")

class UsersController < ApplicationController
    def new
      @user = User.new
    end

    def show
      if session[:user_id]
        @user = User.find(session[:user_id])
        @wallets =  Wallet.where(user_id: @user.id)
      else
        redirect_to login_path
      end
    end

    def register
      @user = User.new(user_params)
      if @user.save
        session[:user_name] = @user.name
        Wallet.create(user_id: @user.id, wallet_number: rand(10**9..10**10 - 1), balance: 0)
        session[:wallet_number] = Wallet.last.wallet_number
        redirect_to home_path
      else
        puts @user.errors.full_messages
        flash[:alert_user] = @user.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity, notice: @user.errors.full_messages.join(", ")
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
        if @user.nil?
          @user = User.new
          flash[:alert_user] = "User not found"
        else
          flash[:alert_user] = "Invalid password or email"
        end

        puts flash[:alert_user]
        render :login, status: :unprocessable_entity, notice: flash[:alert_user]
      end
    end

    def logout
      session[:user_id] = nil
      session[:wallet_number] = nil

      redirect_to home_path, notice: "Successfully logged out"
    end

    private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
