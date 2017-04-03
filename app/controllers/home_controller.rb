class HomeController < ApplicationController
  
	before_action :authenticate_user! , :only => [:user_home, :user_json, :group]
  before_action :set_current_user , :only => [:group]
  before_action :set_group, :only => [:group]
  before_action :check_user_belongs_to_group, :only => [:group]

  def index
  end

  def user_home
  	@user = current_user
  	@groups = current_user.groups
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
    @group_polls = group_polls.where('id NOT IN (?)',group_polls_deleted)
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
