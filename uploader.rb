require 'sinatra/base'
require 'pathname'
require 'fastimage'

require 'pp'



class Uploader < Sinatra::Base

  PUBLIC_DIR     = './public'

  set(:method) do |method|
    method = method.to_s.upcase
    condition { request.request_method == method }
  end

  before :method => :put do

    # check file type
    type = FastImage.type(request.body)
    halt 415 unless approved_type?(type)

    # check file dimensions
    size = FastImage.size(request.body)
    halt 416 unless file_dimensions_within_range?(size)
  end

  put '/upload/:data' do
    image_file = params[:data]
    file_path = "#{PUBLIC_DIR}/#{image_file}"

    File.open(file_path, 'w+') do |file|
      file.write(request.body.read)
    end

  end

  get '/index' do
    @filenames = Dir.glob("#{PUBLIC_DIR}/*.{jpg,JPG,png,PNG}")

    # uncomment the line below to see the images uploaded
    #erb :index
  end

  # In order to upload files using an upload form
  # uncomment and use both "get '/'"
  # and "post '/save_image'" endpoints

  # get '/' do
  #   erb :upload_form
  # end

  # post '/save_image' do
  #
  #   @filename = params[:file][:filename]
  #   file = params[:file][:tempfile]
  #
  #   File.open("./public/#{@filename}", 'wb') do |f|
  #     f.write(file.read)
  #   end
  #
  #   erb :show_image
  # end

  # determines file dimensions eligibility
  # input param: size[width, height]
  # returns boolean
  def file_dimensions_within_range?(size)
    return false if size.nil?

    width = size[0]
    height = size[1]
    return false unless width && height

    (check_range(width) && check_range(height)) ? true : false

  end

  def check_range(dimension)
    dimension >= 350 && dimension <= 5000
  end

  # check file type for eligibility
  # input param: file type symbol
  # returns boolean
  def approved_type?(type)
    return false unless type
    [:jpeg, :jpg, :png].include?(type.downcase) ? true : false
  end

  run! if __FILE__ == $0
end