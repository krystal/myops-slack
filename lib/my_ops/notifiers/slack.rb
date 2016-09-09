require 'my_ops/notifier'
require 'nifty/utils/http'

module MyOps
  module Notifiers
    class Slack < MyOps::Notifier

      self.notifier_name = "Slack"

      def self.config
        MyOps.module_config['myops-slack']
      end

      def collection_trigger_change(collection)
        server_link = "#{MyOps.host_with_protocol}/servers/#{collection.server_id}"
        collection_link = "#{MyOps.host_with_protocol}/servers/#{collection.server_id}/collections/#{collection.id}"
        attachment = {
          :color => Trigger::COLORS[collection.color] || '#000000',
          :footer => "Trigger Notification | Posted by MyOps at #{MyOps.host}",
          :fields => [
            {:title => 'Device', :value => "<#{server_link}|#{collection.server.hostname}>", :short => true},
            {:title => 'Status', :value => collection.status, :short => true},
            {:title => 'Collection', :value => "<#{collection_link}|#{collection.collector.name}>", :short => true},
            collection.last_collection_value ? {:title => "Data", :value => "#{collection.last_collection_value.value} (#{collection.last_collection_value.comment})", :short => true} : nil,
            collection.message.present? ? {:title => 'Message', :value => collection.message} : nil,
          ].compact,
        }
        send_slack_message(:attachments => [attachment])
      end

      def status_change(status)
        link = "#{MyOps.host_with_protocol}/#{status.owner_type.downcase.tableize}/#{status.owner_id}"
        attachment = {
          :color => status.type == 'Down' ? Trigger::COLORS['Red'] : Trigger::COLORS['Green'],
          :fields => [
            {:title => 'Device', :value => "<#{link}|#{status.owner.hostname}>", :short => true},
            {:title => 'Status', :value => status.type, :short => true}
          ],
          :footer => "Device Status Update | Posted by MyOps at #{MyOps.host}"
        }
        send_slack_message(:attachments => [attachment])
      end

      private

      def send_slack_message(options = {})
        json_payload = {
          :text => options[:text],
          :attachments => options[:attachments],
          :channel => self.class.config.channel,
          :username => self.class.config.username || "MyOps",
          :icon_emoji => self.class.config.icon ? ":" + self.class.config.icon + ":" : nil
        }
        Thread.new do
          # We'll run this in the background and not worry too much about the sucess/failure
          # of it for now.
          Nifty::Utils::HTTP.post(self.class.config.url, :json => json_payload.to_json)
        end
      end

    end
  end
end
