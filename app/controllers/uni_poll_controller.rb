class UniPollController < ApplicationController

	before_action :authenticate_user!

	def new 

	end

	def create
		@poll = UniPoll.create(:name => params[:poll_name]);
		UniPollAdminMapping.create(:uni_poll_id => @poll.id, :admin_id => current_user.id)
		contestants = params[:contestant_name]
		contestants.each do |contestant|
			byebug
			@poll.uni_poll_competitor_mappings.create(:competitor_name => contestant)
		end
		return redirect_to '/user_home'
	end

	def dummie
	end


end
