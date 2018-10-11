class V1::UsersController < ApplicationController
  include JSONAPI::ActsAsResourceController

  before_action :authorize_access_request!
end
