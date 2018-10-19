class Api::V1::Protected::UsersController < ApplicationController
  include JSONAPI::ActsAsResourceController

  before_action :authorize_access_request!
end
