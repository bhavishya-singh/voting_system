class HomeController < ApplicationController
  
	before_action :authenticate_user! , :only => [:user_home, :user_json, :group]
  before_action :set_current_user , :only => [:group]
  before_action :set_group, :only => [:group]
  before_action :check_user_belongs_to_group, :only => [:group]

  def index
    if user_signed_in?
      return redirect_to '/user_home'
    end

  end

  def user_home
  	@user = current_user
  	@groups = current_user.groups
    uni_polls_deleted_mapping = current_user.uni_polls_deleted.pluck(:uni_poll_id); 
    @uni_polls = UniPoll.all.order(:created_at => "desc")
    if uni_polls_deleted_mapping.length > 0
      @uni_polls = @uni_polls.where('id NOT IN (?)',uni_polls_deleted_mapping)
    end
  end

  def user_json
  	@groups = current_user.groups
  	render :json => @groups.to_json(:only => [:id,:name])
  end

  def group
    unless (@belongs)
      return redirect_to '/user_home'
    end
    group_polls = @group.group_polls.order(created_at: :desc)
    group_polls_deleted = current_user.group_polls_deleted.pluck(:group_poll_id)
    if group_polls_deleted.length > 0
      @group_polls = group_polls.where('id NOT IN (?)',group_polls_deleted)
    else
      @group_polls = group_polls
    end
  end

  private

  def set_group 
    @group = Group.find(params[:id])
  end

  def check_user_belongs_to_group
    if(GroupUserMapping.where(:user_id => @current_user.id, :group_id => @group.id).first)
      return @belongs = true
    else
      return @belongs = false
    end
  end

  def set_current_user
    @current_user = current_user
  end

end
