class MyOpsSlack < ::Rails::Railtie
  initializer 'myops.slack.initialize' do
    require 'my_ops/notifiers/slack'
  end
end
