class Quandl::Client::Base
module Model
  
  extend ActiveSupport::Concern

  included do

    include Her::Model
    use_api Quandl::Client::Base.her_api
    
    before_save :touch_save_started_at
    after_save :touch_save_finished_at
    
    attr_accessor :save_started_at, :save_finished_at
    
  end
  
  def elapsed_save_time
    return nil unless save_finished_at.is_a?(Time) && save_started_at.is_a?(Time)
    @elapsed_save_time ||= (save_finished_at - save_started_at)
  end
  
  private 
  
  def touch_save_started_at
    self.save_started_at = Time.now
  end
  
  def touch_save_finished_at
    self.save_finished_at = Time.now
  end
  
end
end