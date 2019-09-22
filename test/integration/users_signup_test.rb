require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    # User数に変化が起こらないはず←いまからpostするuserは無効
    assert_no_difference 'User.count' do 
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'  # "div#profile" ~~ <div id="profile">foobar</div>
    assert_select 'div.alert' # "div.nav" ~~ <div class="nav">foobar</div>
    
    # formのところでしているactionにsignup_pathがあるか？form_forだとなんでだめ？
    assert_select 'form[action=?]', signup_path 
  end
end