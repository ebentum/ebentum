module Mixins
  module Search

    extend ActiveSupport::Concern

    module ClassMethods

      def search(query)
        command = {}

        command[:text] = collection.name
        command[:search] = query

        command[:filter] = self.criteria.selector
        if limit = self.criteria.options[:limit]
          command[:limit] = limit
        end

        results = Mongoid.session('default').command(command)

        results["results"].map do |attributes|
          Mongoid::Factory.from_db(self, attributes["obj"], command[:project])
        end

      end

    end

  end
end