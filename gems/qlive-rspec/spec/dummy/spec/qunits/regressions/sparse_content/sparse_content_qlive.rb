module Regressions
  class SparseContentQlive
    include Qlive::Suite

    def pages_to_test
      [ '/#colors/red' ]
    end

    def before_each_request(rack_request)
      Todo.destroy(Todo.all.map(&:id))
    end

  end
end