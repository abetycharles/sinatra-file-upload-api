require File.dirname(__FILE__) + '/uploader.rb'
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'


module RSpecMixin
  include Rack::Test::Methods
  def app() described_class end
end

RSpec.configure { |c| c.include RSpecMixin }

describe Uploader do

  it 'should upload files of correct format and dimensions' do
    allow(FastImage).to receive(:size).and_return([350,350])
    allow(FastImage).to receive(:type).and_return(:jpg)

    put '/upload', :file => Rack::Test::UploadedFile.new("./fixtures/files/test_image.jpg", "image/jpg")
  end

  it 'should return a 416 code for files of wrong dimensions' do
    allow(FastImage).to receive(:size).and_return([250,350])
    allow(FastImage).to receive(:type).and_return(:jpg)

    put '/upload', :file => Rack::Test::UploadedFile.new("./fixtures/files/test_image.png", "image/png")

    expect(last_response.status).to eq 416
  end

  it 'should return a 415 code for files of wrong format' do
    allow(FastImage).to receive(:size).and_return([350,350])
    allow(FastImage).to receive(:type).and_return(:doc)

    put '/upload', :file => Rack::Test::UploadedFile.new("./fixtures/files/test_image.jpg", "image/jpg")

    expect(last_response.status).to eq 415
  end

  it "should load the index page" do
    get '/index'
    expect(last_response.status).to eq 200
  end

  # it "should load the home page" do
  #   get '/'
  #   expect(last_response.status).to eq 200
  # end

end
