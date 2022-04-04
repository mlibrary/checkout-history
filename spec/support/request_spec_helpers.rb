module RequestSpecHelpers
  def authorize
    create(:auth_token)
  end

  def get(path, **args)
    token = AuthToken&.first&.token
    args[:headers] ||= {"Authorization" => "apikey #{token}"} if token
    super
  end

  def put(path, **args)
    token = AuthToken&.first&.token
    args[:headers] ||= {"Authorization" => "apikey #{token}"} if token
    super
  end
end
