require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    # sigupできてればflashは存在する=flash.empty=false→assert_notは通る
    # または、assert_not flash.empty=flashが空であってほしくはない=成功、という解釈
    assert_not flash.empty? 
    assert is_logged_in?
  end

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