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
		if params["public_poll_image"] != nil
			initialize_image @poll
		end
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

	def initialize_image poll
		original_filename = params["public_poll_image"].original_filename
		temp_file_name = SecureRandom.hex+ "." + original_filename.split(".")[1]
		# @image = Image.create(:filename => original_filename, :user_id => resource.id)
		# file_name = resource.id.to_s + "_" + original_filename
		temp_file = params["public_poll_image"]

		begin
			cpoll = UniPoll.where(:poll_picture => temp_file_name).first
			if cpoll
				temp_file_name = SecureRandom.hex+ "." + original_filename.split(".")[1]
			end
		end while cpoll
		poll.poll_picture = temp_file_name
		poll.save!
		File.open(Rails.root.join('public', 'uploads/public_poll_pictures', temp_file_name), 'wb') do |file|
			file.write(temp_file.read)
		end

	end

end
