class GraphqlController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def query
    # 3. Execute queries with your schema
    result = Schema.execute(params[:query], variables: params[:variables])
    render json: result
  end
end
