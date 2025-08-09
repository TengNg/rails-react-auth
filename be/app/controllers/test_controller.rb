class TestController < ApplicationController
  def test
    render json: { msg: "testing", params: }
  end

  def test2
    render json: { msg: "testing 2", params: }
  end
end
