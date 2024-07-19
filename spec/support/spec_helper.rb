module SpecHelper

  def mock_login(user)
  info = {
    email: user.email,
    name: user.display_name,
    uniqname: user.uniqname
  }
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:saml] = OmniAuth::AuthHash.new({
      provider: 'saml',
      uid: '123456',
      info: info
    })
    post user_saml_omniauth_callback_path
    
  end

  def dismiss_browser_dialog
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
    wait.until {
      begin
        page.driver.browser.switch_to.alert
        true
      rescue Selenium::WebDriver::Error::NoAlertPresentError
        false
      end
    }
    page.driver.browser.switch_to.alert.dismiss
  end

  def accept_browser_dialog
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
    wait.until {
      begin
        page.driver.browser.switch_to.alert
        true
      rescue Selenium::WebDriver::Error::NoAlertPresentError
        false
      end
    }
    page.driver.browser.switch_to.alert.accept
  end

  def fill_in_trix_editor(id, with:)
    find(:css, "##{id}").click.set(with)
  end

end
