class CommentPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.present?
  end

  def show?
    true
  end

  def destroy?
    user != nil && (user.admin? || user.present? && user == record.user)
  end
end
