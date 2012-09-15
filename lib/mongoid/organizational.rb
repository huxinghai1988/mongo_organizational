module Mongoid
  module Organizational
    extend ActiveSupport::Concern

    included do |klass|
      klass.class_eval do
        class << self
          alias_method_chain :mongo_session, :organization
        end
      end

    end

    # def inherited(subclass)
    #   self.default_collection_name = subclass.name.collectionize.to_sym
    # end
    # 
    module ClassMethods
      def mongo_session_with_organization
        if current_organization.nil?
          mongo_session_without_organization
        else
          organization_create_session current_organization
        end
      end

      def current_organization
        Thread.current['mongoid_organization'] ||= nil
      end

      def organization_create_session(config)
        database = config[:database]
        Thread.current["mongo_organization_session[#{database}]"] ||= Mongoid::Sessions::Factory.send(:create_session, config) 
      end
    end

    class Sessions

      def self.switch_organization(name)
        config = Mongoid.sessions[:default]
        Thread.current['mongoid_organization'] = name.nil? ? nil : config.merge(:database => name.to_s + '_' + Rails.env)
      end
    end
  end
end