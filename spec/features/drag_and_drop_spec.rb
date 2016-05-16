require 'spec_helper'

describe 'drag and drop', type: :feature, js: true do
  context 'existing things' do
    before(:each) { Thing.delete_all }

    context 'all things at one page' do
      let!(:thing1) { Thing.create! }
      let!(:thing2) { Thing.create! }

      describe 'drag up' do
        let(:thing1_selector) { "li[data-role=thing#{thing1.id}]" }
        let(:thing2_selector) { "li[data-role=thing#{thing2.id}]" }

        subject do
          visit '/'
          page.execute_script "
            $.getScript('/assets/jquery.simulate.js', function(){
              var draggable = $('#{thing1_selector}');
              var droppable = $('#{thing2_selector}');
              var dy = droppable.offset().top - draggable.offset().top - 1;

              draggable.simulate('drag', {dx:0, dy: dy});
            });
          "
          sleep 3

          click_button 'Refresh'
        end

        it 'change first thing position to 0' do
          subject
          expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing1.id}' and @data-position='0']")
        end

        it 'change second thing position to 1' do
          subject
          expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing2.id}' and @data-position='1']")
        end
      end

      describe 'drag down' do
        let!(:thing1) { Thing.create! }
        let!(:thing2) { Thing.create! }

        let(:thing1_selector) { "li[data-role=thing#{thing1.id}]" }
        let(:thing2_selector) { "li[data-role=thing#{thing2.id}]" }

        subject do
          sleep 3

          delta = thing2.sortable_append ? -1 : 1
          page.execute_script "
            $.getScript('/assets/jquery.simulate.js', function(){
              var draggable = $('#{thing2_selector}');
              var droppable = $('#{thing1_selector}');

              var dy = droppable.offset().top - draggable.offset().top + #{delta};

              draggable.simulate('drag', {dx:0, dy: dy});
            });
          "
          sleep 3

          click_button 'Refresh'
        end

        it 'change first thing position to 0' do
          visit '/'
          subject
          expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing1.id}' and @data-position='#{thing1.sortable_append ? 1 : 0}']")
        end

        it 'change second thing position to 1' do
          visit '/'
          subject
          expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing2.id}' and @data-position='#{thing2.sortable_append ? 0 : 1}']")
        end
      end
    end

    # In some cases first thing position may be greater than 0 (pagination, for example)
    context 'second page' do
      describe 'drag up' do
        let!(:thing0) { Thing.create! }
        let!(:thing1) { Thing.create! }
        let!(:thing2) { Thing.create! }

        let(:thing1_selector) { "li[data-role=thing#{thing1.id}]" }
        let(:thing2_selector) { "li[data-role=thing#{thing2.id}]" }

        subject do
          visit '/?min_position=1'
          page.execute_script "
            $.getScript('/assets/jquery.simulate.js', function(){
              var draggable = $('#{thing1_selector}');
              var droppable = $('#{thing2_selector}');
              var dy = droppable.offset().top - draggable.offset().top - 1;

              draggable.simulate('drag', {dx:0, dy: dy});
            });
          "
          sleep 3

          click_button 'Refresh'
        end

        it 'change first thing position to 1' do
          subject
          expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing1.id}' and @data-position='1']")
        end

        it 'change second thing position to 2' do
          subject
          expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing2.id}' and @data-position='2']")
        end
      end

      describe 'drag down' do
        let!(:thing0) { Thing.create! }
        let!(:thing1) { Thing.create! }
        let!(:thing2) { Thing.create! }

        let(:thing1_selector) { "li[data-role=thing#{thing1.id}]" }
        let(:thing2_selector) { "li[data-role=thing#{thing2.id}]" }

        subject do
          visit '/?min_position=1'

          delta = thing2.sortable_append ? -1 : 1
          page.execute_script "
            $.getScript('/assets/jquery.simulate.js', function(){
              var draggable = $('#{thing2_selector}');
              var droppable = $('#{thing1_selector}');

              var dy = droppable.offset().top - draggable.offset().top + #{delta};

              draggable.simulate('drag', {dx:0, dy: dy});
            });
          "
          sleep 3

          click_button 'Refresh'
        end

        it 'change first thing position to 1' do
          subject
          expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing1.id}' and @data-position='#{thing1.sortable_append ? 2 : 1}']")
        end

        it 'change second thing position to 2' do
          subject
          expect(page).to have_selector(:xpath, "//li[@data-role='thing#{thing2.id}' and @data-position='#{thing2.sortable_append ? 1 : 2}']")
        end
      end
    end
  end

  context 'new things' do
    let(:new_parent_path) { '/parents/new' }

    describe 'drag up' do
      let(:child1_selector) { "li[data-position='2']" }
      let(:child2_selector) { "li[data-position='0']" }

      subject do
        visit new_parent_path
        page.execute_script %{
          $.getScript('/assets/jquery.simulate.js', function(){
            var draggable = $("#{child1_selector}");
            var droppable = $("#{child2_selector}");
            var dy = droppable.offset().top - draggable.offset().top - 1;

            draggable.simulate('drag', {dx:0, dy: dy});
          });
        }
        sleep 3

        click_button 'Create Parent'
      end

      it 'change first child position to 2' do
        subject
        expect(page).to have_selector("li[data-position='1']", text: 'Child 0')
      end

      it 'change last child position to 0' do
        subject
        expect(page).to have_selector("li[data-position='0']", text: 'Child 2')
      end
    end

    describe 'drag down' do
      let(:child1_selector) { "li[data-position='2']" }
      let(:child2_selector) { "li[data-position='0']" }

      subject do
        visit new_parent_path
        page.execute_script %{
          $.getScript('/assets/jquery.simulate.js', function(){
            var draggable = $("#{child2_selector}");
            var droppable = $("#{child1_selector}");
            var dy = droppable.offset().top - draggable.offset().top + 1;

            draggable.simulate('drag', {dx:0, dy: dy});
          });
        }
        sleep 3

        click_button 'Create Parent'
      end

      it 'change first child position to 2' do
        subject
        expect(page).to have_selector("li[data-position='2']", text: 'Child 0')
      end

      it 'change middle child position to 0' do
        subject
        expect(page).to have_selector("li[data-position='0']", text: 'Child 1')
      end

      it 'change last child position to 1' do
        subject
        expect(page).to have_selector("li[data-position='1']", text: 'Child 2')
      end
    end
  end
end
