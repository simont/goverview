# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_goverview_session',
  :secret      => '6096d43494cce5aa296fa5b3bf4df57d187637ef3f0efed3cf6e99d7cc476975cf67d71d5240b94a2399f4ce1309f36a65ef77a1323dec2029bdc67f6aa54bb0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
