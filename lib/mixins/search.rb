module Mixins
  module Search

    extend ActiveSupport::Concern

    module ClassMethods

      def search(query)
      	resulttt = []
        session = Mongoid.session('default')
        results = session.command({"text" => collection.name, 'search' => query})
        results["results"].map do |attributes|
          Mongoid::Factory.from_db(self, attributes["obj"])
        end

      end

    end

  end
end