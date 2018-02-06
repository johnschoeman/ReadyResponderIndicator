module IndicatorHelpers
  def every(seconds)
    thr = Thread.new do
      loop do
        sleep seconds
        yield
      end
    end
    thr
  end
end