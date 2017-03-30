class GroupsController < ApplicationController
  
  before_action :set_group, :only => [:edit,:update,:delete,:add_user_to_group]

  def index
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.create(group_params)
    GroupUserMapping.create(:user_id => current_user.id, :group_id => @group.id)
    return redirect_to "/user_home"
  end

  def update
    @group.update(group_params)
    return redirect_to "/user_home"
  end

  def delete
    @group.destroy
  end

  def add_user_to_group
    search_user = params[:search_user_name]
    if(search_user)
      query = "user_name like '%#{search_user}%'"
      @search_user = User.where(query)
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def set_group
    @group = Group.find(params[:id])
  end

end
