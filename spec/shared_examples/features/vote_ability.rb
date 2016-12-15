shared_examples_for 'vote ability' do
  let(:votable_name) { votable.class.name.downcase }

  context 'Authenticated user' do
    context 'not his votable' do
      let(:user) { create(:user) }

      before :each do
        sign_in(user)
        visit votable_page
      end

      scenario 'upvotes a votable', js: true do
        within ".js-#{votable_name}-vote-control" do
          click_on('+1')

          expect(page).to_not have_content('+1')
          expect(page).to_not have_content('-1')
          expect(page).to have_content('Unvote')
        end

        within ".js-#{votable_name}-vote-count" do
          expect(page).to have_content('1')
        end
      end

      scenario 'downvotes a votable', js: true do
        within ".js-#{votable_name}-vote-control" do
          click_on('-1')

          expect(page).to_not have_content('+1')
          expect(page).to_not have_content('-1')
          expect(page).to have_content('Unvote')
        end

        within ".js-#{votable_name}-vote-count" do
          expect(page).to have_content('-1')
        end
      end

      scenario 'removes his vote from a votable', js: true do
        within ".js-#{votable_name}-vote-control" do
          click_on('+1')
          click_on('Unvote')

          expect(page).to have_content('-1')
          expect(page).to have_content('+1')
          expect(page).to_not have_content('Unvote')
        end

        within ".js-#{votable_name}-vote-count" do
          expect(page).to have_content('0')
        end
      end
    end

    context 'his own votable' do
      before :each do
        sign_in(votable.user)
        visit votable_page
      end

      scenario 'tries to upvote an votable', js: true do
        within ".js-#{votable_name}-voting" do
          expect(page).to_not have_content('+1')
        end
      end

      scenario 'tries to downvote a votable', js: true do
        within ".js-#{votable_name}-voting" do
          expect(page).to_not have_content('-1')
        end
      end

      scenario 'tries to remove his vote from a votable', js: true do
        within ".js-#{votable_name}-voting" do
          expect(page).to_not have_content('Unvote')
        end
      end
    end
  end

  context 'Non-authenticated user' do
    before :each do
      visit votable_page
    end

    scenario 'tries to upvote a votable', js: true do
      within ".js-#{votable_name}-voting" do
        expect(page).to_not have_content('+1')
      end
    end

    scenario 'tries to downvote a votable', js: true do
      within ".js-#{votable_name}-voting" do
        expect(page).to_not have_content('-1')
      end
    end
  end
end
