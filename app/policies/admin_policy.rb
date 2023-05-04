class ::AdminPolicy < ApplicationPolicy

  def index?
    user != nil && (user.admin?)
  end

  def destroy?
    user != nil && (user.admin?)
  end

  def update?
    user != nil && (user.admin?)
  end

  def edit?
    user != nil && (user.admin?)
  end
end
