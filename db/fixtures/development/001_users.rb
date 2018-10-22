# frozen_string_literal: true

User.seed_once(
  :email,
  {
    email: 'dan@cybertooth.io',
    first_name: 'Dan',
    last_name: 'Nelson',
    nickname: 'Hollywood',
    password: 'secret',
    password_confirmation: 'secret'
  },
  email: 'bradf.83@gmail.com',
  first_name: 'Brad',
  last_name: 'Fontaine',
  nickname: 'Gorilla',
  password: 'secret',
  password_confirmation: 'secret'
)
