class SchedulesController < ApplicationController

  def best_timetable
    @friends = [current_user] + current_user.relationships.to_a
  end

  def availabilities_timetables
    schedule_context = SocialFramework::ScheduleHelper::ScheduleContext.new
    hash = build_params
    @slots = schedule_context.verify_availabilities(hash[:users], hash[:start_day], hash[:finish_day],
      hash[:start_hour], hash[:finish_hour], hash[:slots_size])

    @duration = hash[:slots_size]

    render action: :show_timetables
  end
  
  def show_timetables
  end

  def mark_event
  end

  private

  def build_params
    users = Hash.new

    params[:friends].each do |id|
      user = SocialFramework::User.find id

      weight = params[:weights][id]

      if weight.empty?
        weight = 1
      elsif weight == "Fixo"
        weight = :fixed
      else
        weight = weight.to_i
      end

      users[user] = weight
    end

    return { users: users, start_day: Date.parse(params[:start_day]),
      finish_day: Date.parse(params[:finish_day]),
      start_hour: Time.parse(params[:start_hour]), finish_hour: Time.parse(params[:finish_hour]),
      slots_size: params[:slots_size].to_i.minutes }
  end
end
