class UniPollController < ApplicationController

	before_action :authenticate_user!
	before_action :set_uni_poll, :only => [:vote,:contribute,:result,:stop_poll]

	def new 

	end

	def create
		@poll = UniPoll.create(:name => params[:poll_name]);
		UniPollAdminMapping.create(:uni_poll_id => @poll.id, :admin_id => current_user.id)
		contestants = params[:contestant_name]
		contestants.each do |contestant|
			@poll.uni_poll_competitor_mappings.create(:competitor_name => contestant)
		end
		if params[:country_based] == "yes"
			@poll.country_based = true
			@poll.country = current_user.country
		else
			@poll.country_based == false
		end
		@poll.save!
		return redirect_to '/user_home'
	end

	def vote
		if @uni_poll.poll_end || UniPollVoterMapping.where(:uni_poll_id => @uni_poll.id,:voter_id => current_user.id).first
			return redirect_to "/unipoll/#{@uni_poll.id}/result"
		else	
			@contestants_mapping = @uni_poll.uni_poll_competitor_mappings
		end

	end

	def contribute
		voter_mapping = UniPollVoterMapping.where(:uni_poll_id => params[:uni_poll_id],:voter_id => current_user.id).first
		unless voter_mapping
			your_fav = params[:your_fav]
			uni_poll_competitor_mapping = UniPollCompetitorMapping.where(:uni_poll_id => params[:uni_poll_id],:competitor_name => your_fav).first
			uni_poll_competitor_mapping.votes = uni_poll_competitor_mapping.votes + 1
			uni_poll_competitor_mapping.save
			UniPollVoterMapping.create(:uni_poll_id => params[:uni_poll_id],:voter_id => current_user.id)
			return redirect_to "/unipoll/#{params[:uni_poll_id]}/result"
		end
		return redirect_to '/user_home'	
	end

	def stop_poll
		if isuserAdminOfPublicPoll? current_user, @uni_poll
			@uni_poll.update(:poll_end => true)
		end
		return redirect_to '/user_home'
	end

	def result
		voter_mapping = UniPollVoterMapping.where(:uni_poll_id => params[:uni_poll_id],:voter_id => current_user.id).first
		unless voter_mapping || @uni_poll.poll_end
			return redirect_to "unipoll/#{params[:uni_poll_id]}/vote"
		end
		@contestants_mapping = @uni_poll.uni_poll_competitor_mappings
	end

	private

	def set_uni_poll
		@uni_poll = UniPoll.find(params[:uni_poll_id])
	end

end
