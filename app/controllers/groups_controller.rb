class GroupsController < ApplicationController
  
  before_action :set_group, :only => [:edit,:update,:delete,:add_user_to_group,:leave_group]

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
    GroupAdminMapping.create(:admin_id => current_user.id, :group_id => @group.id)
    return redirect_to "/user_home"
  end

  def update
    @group.update(group_params)
    return redirect_to "/user_home"
  end

  def delete
    if isUserAdmin? current_user, @group
      @group.destroy
    end
    return redirect_to "/user_home"

  end

  def add_user_to_group
    search_user = params[:search_user_name]
    if(search_user)
      query = "user_name like '%#{search_user}%'"
      @search_user = User.where(query)
    end
    @group_users = @group.users - [current_user]
  end

  def search_json
    search_user = params[:content]
    query = "user_name like '%#{search_user}%'"
    @search_user = User.where(query) - [current_user]
    render :json => @search_user
  end

  def leave_group
    puts "00000000000000000000000000000000000000000000000000"
    puts "00000000000000000000000000000000000000000000000000"
    puts "00000000000000000000000000000000000000000000000000"
    @mapping = GroupUserMapping.where(:group_id => @group.id, :user_id => current_user.id).first
    if @mapping
      puts "1111111111111111111111111111111111111111111111111111"
      if isUserAdmin? current_user, @group
        puts "222222222222222222222222222222222222222222222222222"
        if @group.admins.length < 2 && @group.users.length > 1
          puts "33333333333333333333333333333333333333333333333333333333"
          admin_user = (@group.users - [current_user]).first
          puts admin_user.id
          puts (@group.users - [current_user])
          GroupAdminMapping.create(:group_id => @group.id, :admin_id => admin_user.id)
          GroupAdminMapping.where(:group_id => @group.id, :admin_id => current_user.id).first.destroy 
        end
      end
      @mapping.destroy
    end
    return redirect_to '/user_home'
  end

  def add_user
    @mapp = GroupUserMapping.where(:user_id => params[:user_id], :group_id => params[:group_id]).first
    if(!@mapp)
      if isUserAdmin? current_user, Group.find(params[:group_id])
        @mapp = GroupUserMapping.create(:user_id => params[:user_id], :group_id => params[:group_id])
      end
    end
    render :json => @mapp
  end

  def remove_user
    @mapp = GroupUserMapping.where(:user_id => params[:user_id], :group_id => params[:group_id]).first
    if(@mapp)
      if isUserAdmin? current_user, Group.find(params[:group_id])
        @mapp.destroy
      else
        @mapp = nil
      end
    end
    render :json => @mapp
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def set_group
    @group = Group.find(params[:id])
  end

end