class HelloController < ApplicationController
  def index
    render plain: "Hello Jets via Puma"
  end
end