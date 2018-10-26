# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    module Public
      class RolesControllerTest < ActionDispatch::IntegrationTest
        test 'when index' do
          get api_v1_public_roles_url

          assert_response :ok
        end

        test 'when show' do
          get api_v1_public_role_url(roles(:guest))

          assert_response :ok
        end
      end
    end
  end
end
