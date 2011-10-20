require "factory_girl/step_definitions"

FactoryGirl.factories.each do |factory|
  human_name = factory.human_names.first

  Then /^the following (?:#{human_name}|#{human_name.pluralize}) should exist:$/ do |table|
    table.hashes.each do |human_hash|
      model          = factory.name.to_s.classify.constantize
      attributes     = {}
      attribute_hash = convert_human_hash_to_attribute_hash(human_hash, factory.associations)

      attribute_hash.each do |key, value|
        if value.is_a?(ActiveRecord::Base)
          attributes["#{key}_id".to_sym] = value.id
        else
          attributes[key] = value
        end
      end

      model.first(:conditions => attributes).should_not be_nil
    end
  end
end
