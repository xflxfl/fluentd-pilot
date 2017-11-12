# encoding: utf-8
require 'fluent/filter'

class Fluent::JsonLogFilter < Fluent::Filter
  Fluent::Plugin.register_filter('json_log', self)

  config_param :time_key, :string, :default => 'time'
  config_param :jsonkey, :string, :default => 'log'

  def initialize
    super
  end

  def configure(conf)
    super
  end

  def filter(tag, time, record)
        if record.nil?
                return
        end
    record[@time_key] = Time.now.strftime '%Y-%m-%dT%H:%M:%S.%L'

    begin
      str = record[@jsonkey].gsub(/[\r\n]/,'')
      record[@jsonkey] = JSON.parse(str)
    rescue
       puts 'Not a JSON string'
    end

    return record
  end
end if defined?(Fluent::Filter)