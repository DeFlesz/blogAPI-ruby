class ArticlePolicy < ApplicationPolicy

  def create?
    user.present?
  end

  def index?
    true
  end

  def show?
    true
  end

  def edit?
    update?
  end

  def update?
    user != nil && (user.admin? || user.present? && user == record.user)
  end

  def destroy?
    user != nil && (user.admin? || user.present? && user == record.user)
  end
end
