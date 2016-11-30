module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      provider: provider,
      uid: '123456789',
      info: {
        email: 'example@domain.com'
      }
    })
  end
end
