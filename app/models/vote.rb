class Vote < ApplicationRecord
  belongs_to :votable, optional: true, polymorphic: true
  belongs_to :user

  scope :by_resource, -> (resource) { where(votable_type: resource.class.name, votable_id: resource.id) }
  scope :negative, -> { where('positive is false') }
end
