class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token
  before_action :only_respond_to_json
  before_action :set_short_url, only: [:show]


  def index
    short_urls = ShortUrl.limit(100).order('click_count')
    render json: { urls: short_urls.map {|short_url| short_url.public_attributes } }, status: 200
  end

  def create
    @short_url = ShortUrl.new(short_url_params)

    if @short_url.save
      render json: { short_code: @short_url.short_code }, status: :ok
    else
      render json: {errors: "Full url is not a valid url"}
    end
  end

  def show
    if @short_url
      @short_url.increment!(:click_count)
      redirect_to @short_url.full_url
    else
      render :json => {:error => "not-found"}.to_json, :status => 404
    end
  end

  private

  def only_respond_to_json
    head :not_acceptable unless params[:format] == 'json'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_short_url
    @short_url = ShortUrl.find_by_short_code(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def short_url_params
    params.permit(:full_url)
  end
end
