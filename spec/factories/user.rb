FactoryGirl.define do
  factory :user do
    email { "user#{Time.now.to_f}#{rand(1000)}@angelboy.com" }
    password  "1234"
    # role_name ""
    name { s = "XXX"; 14.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }; s }

  end

end