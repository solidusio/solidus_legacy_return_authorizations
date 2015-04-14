module AuthenticationSupport
  def stub_api_controller_authentication!(options={})
    @current_api_user = options[:admin] ? create(:admin_user) : create(:user)
    controller.stub(:load_user)
    controller.instance_variable_set(:@current_api_user, @current_api_user)
  end
end
