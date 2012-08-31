module Qlive
  module Matchers
    def self.add_matchers
      ::RSpec::Matchers.define :pass_qunit_tests do |failure_text|
        match do |page_actual|
          url = page_actual.current_url
          passed = page_actual.find('#qunit-testresult .passed').text.to_i rescue 0
          failed = page_actual.find('#qunit-testresult .failed').text.to_i rescue 1
          Qlive.logger.info "#{url } passed: #{passed}, failed: #{failed}"

          failed == 0 && passed > 0
        end

        failure_message_for_should do |page_actual|
          "qunit failure text: #{failure_text}"
        end

        failure_message_for_should_not do |page_actual|
          "expected qunit test to fail but all passed."
        end

        description do
          "pass qunit tests"
        end
      end
    end
  end
end