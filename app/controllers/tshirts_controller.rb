require "open-uri"

class TshirtsController < ApplicationController
  def index
    @tshirts = Tshirt.all
  end
  def show
    @tshirt = Tshirt.find(params[:id])
    if !@tshirt.match.nil?
      @matched_word = @tshirt.caption.split[@tshirt.match].downcase
    end
  end
  def new
    @tshirt = Tshirt.new
  end
  def create
    @tshirt = Tshirt.create!(params[:tshirt])
    redirect_to tshirt_path(@tshirt)
  end
  def edit
    @tshirt = Tshirt.find(params[:id])
  end
  def update
    @tshirt = Tshirt.find(params[:id])
    @tshirt.update_attributes(params[:tshirt])
    redirect_to tshirt_path(@tshirt)
  end
  def destroy
    Tshirt.find(params[:id]).destroy
    redirect_to tshirts_path
  end
end
