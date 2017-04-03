class GroupPollsController < ApplicationController

  before_action :authenticate_user!  
  before_action :set_group, :only => [:new,:create]
  before_action :set_group_poll, :only => [:vote, :result, :contribute]

  def index
  end

  def new
    if isUserAdmin? current_user, @group
      @members = @group.users
    else
      return redirect_to '/user_home'
    end
  end

  def create
    if isUserAdmin? current_user, @group
    	contestant_list = params[:contestant_ids]
      @group_poll = GroupPoll.create(:group_id => @group.id, :name => params[:name])
      contestant_list.each do |contestant_id|
        @group_poll.group_poll_competitor_mappings.create(:competitor_id => contestant_id)
      end
    end
    return redirect_to '/user_home'
  end

  def vote
    poll_voter_mapping = GroupPollVoterMapping.where(:group_poll_id => params[:group_poll_id], :voter_id => current_user.id).first
    if poll_voter_mapping
      return redirect_to "/group_polls/#{params[:group_poll_id]}/result"     
    end  
    @poll_contestants = @group_poll.competitors


  end

  def contribute
    @group_poll = GroupPoll.find(params[:group_poll_id])
    if check_user_belongs_to_group current_user, @group_poll.group
      poll_voter_mapping = GroupPollVoterMapping.where(:group_poll_id => params[:group_poll_id], :voter_id => current_user.id).first
      unless poll_voter_mapping
        contestant_mapping = GroupPollCompetitorMapping.where(:group_poll_id => params[:group_poll_id],:competitor_id => params[:your_fav]).first
        vote = contestant_mapping.votes + 1;
        contestant_mapping.update(:votes => vote)
        GroupPollVoterMapping.create(:group_poll_id => params[:group_poll_id],:voter_id => current_user.id) 
        return redirect_to "/user_home"
      end 
    end
    return redirect_to "/user_home"
  end

  def result
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def check_user_belongs_to_group user, group
    if(GroupUserMapping.where(:user_id => user.id, :group_id => group.id).first)
      return true
    else
      return false
    end
  end

  def set_group_poll
    @group_poll = GroupPoll.find(params[:group_poll_id])
  end

end