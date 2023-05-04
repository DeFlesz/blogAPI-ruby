class CommentPolicy < ApplicationPolicy

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
