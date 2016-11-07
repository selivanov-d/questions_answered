class Vote < ApplicationRecord
  belongs_to :votable, optional: true, polymorphic: true
end
