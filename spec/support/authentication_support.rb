module AuthenticationSupport
  def stub_api_controller_authentication!(options={})
    @current_api_user = options[:admin] ? create(:admin_user) : create(:user)
    warden = double(:warden, user: @current_api_user, authenticate: @current_api_user)
    controller.stub(:env).and_return({'warden' => warden})
    controller.request.env['warden'] = warden
  end
end
