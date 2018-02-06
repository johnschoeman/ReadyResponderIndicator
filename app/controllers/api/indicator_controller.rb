class Api::IndicatorController < ApplicationController
  include IndicatorHelpers

  def index
    render :index
  end

  def new
  end

  def start_poll
    set_staffing_level
    thread = every(12.seconds) { set_staffing_level }
    thread[:poll_worker] = true
    flash[:notice] = "Polling has started."
    redirect_to '/api/index'
  end

  def stop_poll
    puts "stoping poll"

    Thread.list.each do |thread|
      if thread[:poll_worker]
        puts "exiting thread: #{thread}"
        thread.exit 
      end
    end
    flash[:notice] = "Polling has stopped."
    redirect_to '/api/index'
  end

  def test
    puts "testing"
  end

  def set_staffing_level
    res = Faraday.get ENV['READY_RESPONDER_STAFFING_API']
    new_state = JSON.parse(res.body)
    puts "#{Time.zone.now.strftime('%c')}: #{new_state}"
    Indicator::Indicator.update_state(new_state)
  end
end
