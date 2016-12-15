shared_examples_for 'comment ability' do
  let(:commentable_name) { commentable.class.name.downcase }

  context 'Authenticated user' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
      visit commentable_page
    end

    scenario 'creates comment with valid data', js: true do
      within ".js-new-comment[data-#{commentable_name}-id='#{commentable.id}']" do
        find('.js-new-comment-trigger').click

        fill_in 'comment_content', with: "Test #{commentable_name} comment"

        click_on 'Сохранить комментарий'
      end

      expect(current_path).to eq commentable_page

      within ".js-comments-for-#{commentable_name}-list" do
        expect(page).to have_content("Test #{commentable_name} comment")
      end
    end

    scenario 'creates comment with invalid data', js: true do
      within ".js-new-comment[data-#{commentable_name}-id='#{commentable.id}']" do
        find('.js-new-comment-trigger').click

        fill_in 'comment_content', with: 'no_text'

        click_on 'Сохранить комментарий'
      end

      expect(current_path).to eq commentable_page

      within ".js-comments-for-#{commentable_name}-list" do
        expect(page).to_not have_content('no_text')
      end
    end
  end

  context 'Non-authenticated user' do
    scenario 'tries to create comment', js: true do
      visit commentable_page

      expect(page).to_not have_css(".js-new-comment[data-#{commentable_name}-id='#{commentable.id}']")
    end
  end

  context 'All users get new comments in real-time' do
    before :each do
      guest = create(:user)
      author = create(:user)

      Capybara.using_session('authenticated_author_creator') do
        sign_in(author)
        visit commentable_page
      end

      Capybara.using_session('authenticated_author_reader') do
        sign_in(author)
        visit commentable_page
      end

      Capybara.using_session('authenticated_guest') do
        sign_in(guest)
        visit commentable_page
      end

      Capybara.using_session('non_authenticated_guest') do
        visit commentable_page
      end

      Capybara.using_session('authenticated_author_creator') do
        within ".js-new-comment[data-#{commentable_name}-id='#{commentable.id}']" do
          find('.js-new-comment-trigger').click

          fill_in 'comment_content', with: "New comment for #{commentable_name} test content"

          click_on 'Сохранить комментарий'
        end
      end
    end

    %w(authenticated_guest non_authenticated_guest authenticated_author_reader authenticated_author_creator).each do |role|
      scenario "#{role} sees new comment", js: true do
        Capybara.using_session(role) do
          within ".js-comments-for-#{commentable_name}-list" do
            expect(page).to have_content "New comment for #{commentable_name} test content"
          end
        end
      end
    end
  end
end
