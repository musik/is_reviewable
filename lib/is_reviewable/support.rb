module IsReviewable
  module Support

    class << self

      # Check if object is a valid activerecord object.
      #
      def is_active_record?(object)
        object.present? && object.is_a?(::ActiveRecord::Base)
      end

      # Check if input is a valid format of IP, i.e. "#.#.#.#". Note: Just basic validation.
      #
      def is_ip?(object)
        (object =~ /^\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}$/) rescue false
      end

      # Hash conditions to array conditions converter,
      # e.g. {:key => value} will be turned to: ['key = :key', {:key => value}]
      #
      def hash_conditions_as_array(conditions)
        [conditions.keys.collect { |key| "#{key} = :#{key}" }.join(' AND '), conditions]
      end

    end
    
  end
end