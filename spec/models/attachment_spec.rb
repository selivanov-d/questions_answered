require 'rails_helper'

describe Attachment, type: :model do
  it { should belong_to(:attachable) }
end
