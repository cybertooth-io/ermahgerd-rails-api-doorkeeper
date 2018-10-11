class V1::UserResource < JSONAPI::Resource
  attributes(
    :email,
    :first_name,
    :last_name,
    :nickname,
    {}
  )
end
