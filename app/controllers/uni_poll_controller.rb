class UniPollController < ApplicationController

	before_action :authenticate_user!
	before_action :set_uni_poll, :only => [:vote,:contribute,:result,:stop_poll]

	def new 

	end

	def create
		@poll = UniPoll.create(:name => params[:poll_name], :start_date => params[:start_date]);
		UniPollAdminMapping.create(:uni_poll_id => @poll.id, :admin_id => current_user.id)
		contestants = params[:contestant_name]
		contestant_no = 0;
		contestants.each do |contestant|
			@mapping = @poll.uni_poll_competitor_mappings.create(:competitor_name => contestant, :contestant_tag_line => params[:contestant_tag_line][contestant_no])
			if params[:contestant_pic_set][contestant_no] != 'false'
				@mapping.contestant_picture = params[:contestant_pic_set][contestant_no]
				@mapping.save!
			else
				@mapping.contestant_picture = "user.png"
				@mapping.save!
			end
			contestant_no = contestant_no + 1;
		end

		if params[:country_based] == "yes"
			@poll.country_based = true
			@poll.country = current_user.country
		else
			@poll.country_based == false
		end
		@poll.save!
		if params["public_poll_hidden_image"] != 'not_set'
			@poll.poll_picture = params["public_poll_hidden_image"]
			@poll.save!
		end
		return redirect_to '/user_home'
	end

	def vote
		if @uni_poll.start_date > Time.now
			return redirect_to "/user_home", :alert => "Voting will soon be started @ #{@uni_poll.start_date}"
		end
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
			uni_poll_competitor_mapping = UniPollCompetitorMapping.find(your_fav)
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
		if !@uni_poll.poll_end
			return redirect_to "/user_home" ,:alert =>  "Results will soon be shared"
		end
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

	def initilize_image_contestant mapping, contestant_number
		if  params[:contestant_pic] && params[:contestant_pic][contestant_number]
		original_filename = params[:contestant_pic][contestant_number].original_filename
		temp_file_name = SecureRandom.hex+ "." + original_filename.split(".")[1]
		temp_file = params[:contestant_pic][contestant_number]
		begin
			entry = UniPollCompetitorMapping.where(:contestant_picture => temp_file_name).first
			if entry
				temp_file_name = SecureRandom.hex+ "." + original_filename.split(".")[1]
			end
		end while entry
		mapping.contestant_picture = temp_file_name
		mapping.save!
			File.open(Rails.root.join('public', 'uploads/public_contestants', temp_file_name), 'wb') do |file|
				file.write(temp_file.read)
			end
		end
	end
end
